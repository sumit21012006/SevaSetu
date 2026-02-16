import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'dart:convert';
import '../services/document_provider.dart';
import '../services/auth_service.dart';
import '../models/models.dart';
import '../widgets/global_voice_assistant.dart';
import '../theme/design_system.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  dynamic _image;
  File? _pdfFile;
  PlatformFile? _webPdfFile;
  XFile? _imageFile;
  bool _isProcessing = false;
  bool _isPdfMode = false;
  String? _extractedText;
  DateTime? _issueDate;
  DateTime? _expiryDate;
  String _documentType = 'SSC Marksheet';
  String _selectedCategory = 'Marksheets';
  String? _imageBase64;
  String _customDocumentName = '';
  TextEditingController? _customDocController;

  final Map<String, List<String>> _documentCategories = {
    'Marksheets': [
      'SSC Marksheet',
      'HSC Marksheet',
      'B-Tech Marksheet (Renewal)',
      'MHT-CET Result',
    ],
    'Personal Identity': [
      'Aadhaar Card',
      'PAN Card',
      'Passport Photo',
      'Age Proof',
      'Address Proof',
    ],
    'Certificates': [
      'Income Certificate',
      'Caste Certificate',
      'Caste Validity',
      'Non-Creamy Layer',
      'Nationality & Domicile Certificate',
      'Birth Certificate',
      'Marriage Certificate',
    ],
    'Application Documents': [
      'Mahadbt Application Form',
      'HSC LC',
      'Undertaking',
      'Learner License',
      'Driving License',
    ],
    'Financial Documents': [
      'Ration Card',
      'Salary Slip',
      'Property Documents',
    ],
    'Other': ['Other'],
  };

  List<String> get _allDocumentTypes {
    final list = <String>[];
    _documentCategories.forEach((category, docs) {
      list.addAll(docs);
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    _customDocController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        final isPdfMode = args['isPdfMode'] as bool?;
        final documentType = args['documentType'] as String?;

        if (isPdfMode == true) {
          setState(() {
            _isPdfMode = true;
          });
        }

        // Auto-set document type if coming from service context
        if (documentType != null) {
          setState(() {
            // Find the category that contains this document type
            String? foundCategory;
            for (final entry in _documentCategories.entries) {
              if (entry.value.contains(documentType)) {
                foundCategory = entry.key;
                break;
              }
            }

            // Only set if we found a valid category, otherwise use default
            if (foundCategory != null) {
              _selectedCategory = foundCategory;
              _documentType = documentType;
            } else {
              // If document type not found in categories, set to 'Other' and use custom name
              _selectedCategory = 'Other';
              _documentType = 'Other';
              _customDocumentName = documentType;
              _customDocController?.text = documentType;
            }
          });
        }
      }
    });
  }

  Future<void> _pickAndScanDocument() async {
    if (_isPdfMode) {
      await _pickPdfFile();
    } else {
      await _pickAndScanImage();
    }
  }

  Future<void> _pickAndScanImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) return;

      setState(() {
        _imageFile = image;
        if (!kIsWeb) {
          _image = File(image.path);
        }
        _pdfFile = null;
        _webPdfFile = null;
        _isProcessing = true;
      });

      // Convert image to base64 for web storage
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBase64 = base64Encode(bytes);
        });
      }

      // Perform OCR to extract text from image
      String extractedText = '';
      if (!kIsWeb) {
        try {
          final inputImage = InputImage.fromFilePath(image.path);
          final textRecognizer =
              TextRecognizer(script: TextRecognitionScript.latin);
          final RecognizedText recognizedText =
              await textRecognizer.processImage(inputImage);

          for (TextBlock block in recognizedText.blocks) {
            for (TextLine line in block.lines) {
              extractedText += '${line.text}\n';
            }
          }

          await textRecognizer.close();
        } catch (e) {
          debugPrint('OCR Error: $e');
          extractedText = 'Could not extract text from image';
        }
      } else {
        // For web, simulate OCR with placeholder
        await Future.delayed(const Duration(seconds: 1));
        extractedText = 'Document scanned successfully';
      }

      // Extract dates from the recognized text
      final dates = _extractDatesFromText(extractedText);

      setState(() {
        _isProcessing = false;
        _extractedText =
            extractedText.isNotEmpty ? extractedText : 'Document scanned';
        _issueDate = dates['issue'];
        _expiryDate = dates['expiry'];
      });
      _animationController.forward();

      if (mounted && (_issueDate != null || _expiryDate != null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Document scanned! Dates: Issue ${_issueDate != null ? _formatDate(_issueDate!) : 'N/A'}, Expiry ${_expiryDate != null ? _formatDate(_expiryDate!) : 'N/A'}',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, DateTime?> _extractDatesFromText(String text) {
    DateTime? issueDate;
    DateTime? expiryDate;

    // Common date patterns: DD/MM/YYYY, DD-MM-YYYY, YYYY-MM-DD
    final datePattern =
        RegExp(r'(\d{1,2}[/-]\d{1,2}[/-]\d{4}|\d{4}[/-]\d{1,2}[/-]\d{1,2})');
    final matches = datePattern.allMatches(text);

    final List<DateTime> foundDates = [];
    for (var match in matches) {
      try {
        final dateStr = match.group(0)!;
        DateTime? date = _parseDate(dateStr);
        if (date != null) {
          foundDates.add(date);
        }
      } catch (e) {
        debugPrint('Date parsing error: $e');
      }
    }

    // Sort dates to identify issue and expiry
    if (foundDates.length >= 2) {
      foundDates.sort();
      issueDate = foundDates[0]; // Earliest date is issue date
      expiryDate =
          foundDates[foundDates.length - 1]; // Latest date is expiry date
    } else if (foundDates.length == 1) {
      // If only one date, assume it's expiry date
      expiryDate = foundDates[0];
    }

    // Look for specific keywords
    final textLower = text.toLowerCase();
    if (textLower.contains('valid') || textLower.contains('issue')) {
      // Try to find issue date near 'issue' or 'valid' keywords
      if (issueDate == null && foundDates.isNotEmpty) {
        issueDate = foundDates[0];
      }
    }
    if (textLower.contains('expiry') ||
        textLower.contains('expire') ||
        textLower.contains('valid upto')) {
      // Try to find expiry date near these keywords
      if (expiryDate == null && foundDates.isNotEmpty) {
        expiryDate = foundDates[foundDates.length - 1];
      }
    }

    return {'issue': issueDate, 'expiry': expiryDate};
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Try DD/MM/YYYY format
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
      // Try DD-MM-YYYY format
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          // Check if first part is year (YYYY-MM-DD)
          if (parts[0].length == 4) {
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            return DateTime(year, month, day);
          } else {
            // DD-MM-YYYY
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            return DateTime(year, month, day);
          }
        }
      }
    } catch (e) {
      debugPrint('Date parse error for $dateStr: $e');
    }
    return null;
  }

  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) return;

      setState(() {
        if (kIsWeb) {
          _webPdfFile = result.files.first;
          _image = null;
        } else {
          _pdfFile = File(result.files.single.path!);
          _image = null;
        }
        _isProcessing = false;
        _extractedText = null;
        _issueDate = null;
        _expiryDate = null;
      });

      _animationController.forward();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.white),
              const SizedBox(width: 12),
              Text('PDF selected: ${_getFileName()}'),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getFileName() {
    if (kIsWeb && _webPdfFile != null) {
      return _webPdfFile!.name;
    } else if (_pdfFile != null) {
      return _pdfFile!.path.split('/').last;
    }
    return 'document.pdf';
  }

  String _getFileSize() {
    if (kIsWeb && _webPdfFile != null) {
      return '${(_webPdfFile!.size / 1024).toStringAsFixed(2)} KB';
    } else if (_pdfFile != null) {
      return '${(_pdfFile!.lengthSync() / 1024).toStringAsFixed(2)} KB';
    }
    return '0 KB';
  }

  void _saveDocument() {
    String? imageDataUri;

    // For web images, create a data URI
    if (kIsWeb && !_isPdfMode && _imageBase64 != null) {
      imageDataUri = 'data:image/png;base64,$_imageBase64';
    }

    // Get authenticated user's ID
    final authService = context.read<AuthService>();
    final userId = authService.userId ?? 'anonymous';

    // Validate expiry date and determine status
    final documentStatus = _validateDocumentExpiry(_expiryDate);

    final newDoc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: _documentType == 'Other' && _customDocumentName.isNotEmpty
          ? _customDocumentName
          : _documentType,
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      status: documentStatus,
      filePath: _isPdfMode
          ? (kIsWeb ? _webPdfFile?.name : _pdfFile?.path)
          : imageDataUri ?? (kIsWeb ? null : _imageFile?.path),
      fileName: _getFileName(),
      isPdf: _isPdfMode,
      createdAt: DateTime.now(),
      imageData: _imageBase64,
    );

    // Add document to provider
    final provider = context.read<DocumentProvider>();
    provider.addDocument(newDoc);

    // Show appropriate success message based on document status
    String statusMessage = '';
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;

    if (documentStatus == 'Expired') {
      statusMessage = 'Document saved but is EXPIRED!';
      statusColor = Colors.red;
      statusIcon = Icons.warning;
    } else if (documentStatus == 'Valid') {
      statusMessage = '${_isPdfMode ? "PDF" : "Document"} saved successfully!';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else {
      statusMessage = '${_isPdfMode ? "PDF" : "Document"} saved successfully!';
      statusColor = Colors.blue;
      statusIcon = Icons.info;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(statusIcon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(statusMessage)),
          ],
        ),
        backgroundColor: statusColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Wait a moment then navigate back to show the new document
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  /// Validates document expiry and returns appropriate status
  String _validateDocumentExpiry(DateTime? expiryDate) {
    if (expiryDate == null) {
      return 'Valid'; // Documents without expiry are considered valid
    }

    final today = DateTime.now();
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final todayNormalized = DateTime(today.year, today.month, today.day);

    if (expiry.isBefore(todayNormalized)) {
      return 'Expired';
    } else if (expiry.isAfter(todayNormalized)) {
      // Check if expiry is within 30 days (warning period)
      final warningThreshold = todayNormalized.add(const Duration(days: 30));
      if (expiry.isBefore(warningThreshold)) {
        return 'Expiring Soon';
      }
      return 'Valid';
    } else {
      // Expiry date is today
      return 'Expiring Soon';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Upload Document',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Upload Option
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPdfMode = false;
                      _image = null;
                      _pdfFile = null;
                      _webPdfFile = null;
                      _extractedText = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !_isPdfMode
                          ? Colors.blue.shade500.withOpacity(0.9)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !_isPdfMode
                            ? Colors.blue.shade300
                            : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 24,
                      color: !_isPdfMode ? Colors.white : Colors.blue.shade300,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // PDF Upload Option
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPdfMode = true;
                      _image = null;
                      _pdfFile = null;
                      _webPdfFile = null;
                      _extractedText = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isPdfMode
                          ? Colors.red.shade500.withOpacity(0.9)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isPdfMode
                            ? Colors.red.shade300
                            : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 24,
                      color: _isPdfMode ? Colors.white : Colors.red.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Document Type Selector with dropdown
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.description,
                                color: Colors.blue.shade700, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Text('Document Type',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Category Selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue.shade200, width: 2),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            prefixIcon: Icon(Icons.category,
                                color: Colors.blue.shade600),
                            labelText: 'Category',
                            labelStyle: TextStyle(
                                color: Colors.blue.shade700, fontSize: 12),
                          ),
                          items: _documentCategories.keys
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600))))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCategory = val!;
                              _documentType = _documentCategories[val]!.first;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Document Type Selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue.shade200, width: 2),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _documentType,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            prefixIcon: Icon(Icons.folder_open,
                                color: Colors.blue.shade600),
                            labelText: 'Document',
                            labelStyle: TextStyle(
                                color: Colors.blue.shade700, fontSize: 12),
                          ),
                          items: _documentCategories[_selectedCategory]!
                              .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500))))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _documentType = val!;
                              if (_documentType != 'Other') {
                                _customDocController?.clear();
                                _customDocumentName = '';
                              }
                            });
                          },
                        ),
                      ),
                      if (_documentType == 'Other') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _customDocController,
                          decoration: InputDecoration(
                            hintText: 'Type document name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade200, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade200, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade600, width: 2),
                            ),
                            prefixIcon:
                                Icon(Icons.edit, color: Colors.blue.shade600),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          onChanged: (val) =>
                              setState(() => _customDocumentName = val),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Upload Area with drag-drop style
                if (_image == null && _pdfFile == null && _webPdfFile == null)
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isPdfMode
                            ? [Colors.red.shade50, Colors.white]
                            : [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isPdfMode
                            ? Colors.red.shade200
                            : Colors.blue.shade200,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isPdfMode ? Colors.red : Colors.blue)
                              .withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isProcessing ? null : _pickAndScanDocument,
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: (_isPdfMode ? Colors.red : Colors.blue)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPdfMode
                                    ? Icons.picture_as_pdf
                                    : Icons.cloud_upload,
                                size: 64,
                                color: _isPdfMode
                                    ? Colors.red.shade600
                                    : Colors.blue.shade600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _isPdfMode
                                  ? 'Upload PDF Document'
                                  : 'Upload Image Document',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isPdfMode
                                    ? Colors.red.shade700
                                    : Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isPdfMode
                                  ? 'Tap to select PDF file'
                                  : 'Tap to select image & scan with AI',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: (_isPdfMode ? Colors.red : Colors.blue)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app,
                                      size: 18,
                                      color: _isPdfMode
                                          ? Colors.red.shade700
                                          : Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Click to browse',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _isPdfMode
                                          ? Colors.red.shade700
                                          : Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // PDF Preview Card
                if (_isPdfMode && (_pdfFile != null || _webPdfFile != null))
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.picture_as_pdf,
                                size: 48, color: Colors.red.shade700),
                          ),
                          const SizedBox(height: 16),
                          Text(_getFileName(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('PDF • ${_getFileSize()}',
                                style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Image Preview
                if (!_isPdfMode && _image != null)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade50, Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image,
                                          size: 80,
                                          color: Colors.blue.shade300),
                                      const SizedBox(height: 12),
                                      const Text('Document Image Selected',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            : Image.file(_image as File, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Processing Indicator
                if (_isProcessing)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(strokeWidth: 3),
                        const SizedBox(height: 16),
                        Text(
                          _isPdfMode
                              ? 'Processing PDF...'
                              : 'AI is extracting dates...',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                // OCR Results for Images
                if (!_isPdfMode && _extractedText != null)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.green.shade100
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green.shade700, size: 32),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('AI Extraction Complete!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultCard(
                            'Issue Date',
                            _issueDate != null
                                ? _formatDate(_issueDate!)
                                : 'Not detected',
                            _issueDate != null ? Colors.green : Colors.orange,
                            _issueDate != null
                                ? Icons.check_circle
                                : Icons.warning),
                        const SizedBox(height: 12),
                        _buildResultCard(
                            'Expiry Date',
                            _expiryDate != null
                                ? _formatDate(_expiryDate!)
                                : 'Not detected',
                            _expiryDate != null ? Colors.green : Colors.orange,
                            _expiryDate != null
                                ? Icons.check_circle
                                : Icons.warning),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                // Save Button
                if ((_isPdfMode && (_pdfFile != null || _webPdfFile != null)) ||
                    (!_isPdfMode && _extractedText != null))
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _saveDocument,
                        icon: const Icon(Icons.save_rounded, size: 24),
                        label: const Text('Save Document',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildResultCard(
      String label, String value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  void dispose() {
    _animationController.dispose();
    _customDocController?.dispose();
    super.dispose();
  }
}
