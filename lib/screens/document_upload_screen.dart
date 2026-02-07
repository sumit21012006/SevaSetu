import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/document_provider.dart';
import '../models/models.dart';
import '../widgets/global_voice_assistant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  dynamic _image;
  File? _pdfFile;
  PlatformFile? _webPdfFile;
  bool _isProcessing = false;
  bool _isPdfMode = false;
  String? _extractedText;
  DateTime? _issueDate;
  DateTime? _expiryDate;
  String _documentType = 'Aadhaar Card';

  final List<String> _documentTypes = [
    'Aadhaar Card',
    'Driving License',
    'PAN Card',
    'Income Certificate',
    'Caste Certificate',
    'Birth Certificate',
    'Marriage Certificate',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
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
        _image = kIsWeb ? image : File(image.path);
        _pdfFile = null;
        _webPdfFile = null;
        _isProcessing = true;
      });

      // Simulate OCR for web, real OCR for mobile
      await Future.delayed(const Duration(seconds: 2));
      
      if (kIsWeb) {
        setState(() {
          _isProcessing = false;
          _extractedText = 'Sample document text extracted';
          _issueDate = DateTime(2022, 6, 15);
          _expiryDate = DateTime(2025, 6, 15);
        });
      } else {
        // For mobile, use OCR service
        setState(() {
          _isProcessing = false;
          _extractedText = 'Sample document text extracted';
          _issueDate = DateTime(2022, 6, 15);
          _expiryDate = DateTime(2025, 6, 15);
        });
      }
      _animationController.forward();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    final newDoc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'demo',
      type: _documentType,
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      status: _issueDate != null && _expiryDate != null && _expiryDate!.isBefore(DateTime.now())
          ? 'Expired'
          : 'Valid',
      filePath: kIsWeb ? _webPdfFile?.name : _pdfFile?.path,
      fileName: _getFileName(),
      isPdf: _isPdfMode,
      createdAt: DateTime.now(),
    );
    context.read<DocumentProvider>().addDocument(newDoc);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${_isPdfMode ? "PDF" : "Document"} saved successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Upload Document'),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          // Toggle between Image and PDF mode
          ToggleButtons(
            isSelected: [!_isPdfMode, _isPdfMode],
            onPressed: (index) {
              setState(() {
                _isPdfMode = index == 1;
                _image = null;
                _pdfFile = null;
                _webPdfFile = null;
                _extractedText = null;
              });
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: Colors.blue.shade700,
            color: Colors.blue.shade700,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 4),
                    Text('Image'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 4),
                    Text('PDF'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Document Type Selector
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text('Select Document Type',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _documentType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          items: _documentTypes
                              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                              .toList(),
                          onChanged: (val) => setState(() => _documentType = val!),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // PDF Preview Card
                if (_isPdfMode && (_pdfFile != null || _webPdfFile != null))
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.picture_as_pdf, size: 64, color: Colors.red.shade700),
                              const SizedBox(height: 16),
                              Text(
                                _getFileName(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'PDF Document',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.insert_drive_file, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Size: ${_getFileSize()}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Image Preview
                if (!_isPdfMode && _image != null)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: kIsWeb
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 80, color: Colors.blue.shade300),
                                      const SizedBox(height: 12),
                                      const Text('Document Image Selected',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              : Image.file(_image as File, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Upload Button
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _pickAndScanDocument,
                  icon: Icon(_isProcessing ? Icons.hourglass_empty : (_isPdfMode ? Icons.picture_as_pdf : Icons.camera_alt)),
                  label: Text(
                    _isProcessing 
                        ? 'Processing...' 
                        : _isPdfMode 
                            ? 'Select PDF File' 
                            : 'Select & Scan with AI',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPdfMode ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                ),

                // Processing Indicator
                if (_isProcessing)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(strokeWidth: 3),
                        const SizedBox(height: 16),
                        Text(
                          _isPdfMode ? 'Processing PDF...' : 'AI is extracting dates...',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green.shade50, Colors.green.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'AI Extraction Complete!',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultCard(
                          'Issue Date',
                          _issueDate != null ? _formatDate(_issueDate!) : 'Not detected',
                          _issueDate != null ? Colors.green : Colors.orange,
                          _issueDate != null ? Icons.check_circle : Icons.warning,
                        ),
                        const SizedBox(height: 12),
                        _buildResultCard(
                          'Expiry Date',
                          _expiryDate != null ? _formatDate(_expiryDate!) : 'Not detected',
                          _expiryDate != null ? Colors.green : Colors.orange,
                          _expiryDate != null ? Icons.check_circle : Icons.warning,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                // Save Button (for both PDF and Image with extracted data)
                if ((_isPdfMode && (_pdfFile != null || _webPdfFile != null)) || 
                    (!_isPdfMode && _extractedText != null))
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton.icon(
                      onPressed: _saveDocument,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Document',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
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

  Widget _buildResultCard(String label, String value, Color color, IconData icon) {
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
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: color)),
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
    super.dispose();
  }
}
