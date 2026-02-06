import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/ocr_service.dart';
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
  final OCRService _ocrService = OCRService();
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  dynamic _image;
  bool _isProcessing = false;
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
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      
      if (image == null) return;

      setState(() {
        if (kIsWeb) {
          _image = image;
        } else {
          _image = File(image.path);
        }
        _isProcessing = true;
      });

      // Simulate OCR for web, real OCR for mobile
      await Future.delayed(const Duration(seconds: 2));
      
      if (kIsWeb) {
        // Mock data for web
        setState(() {
          _isProcessing = false;
          _extractedText = 'Sample document text extracted';
          _issueDate = DateTime(2022, 6, 15);
          _expiryDate = DateTime(2025, 6, 15);
        });
        _animationController.forward();
      } else {
        final result = await _ocrService.extractDocumentInfo(image.path);
        setState(() {
          _isProcessing = false;
          if (result['success']) {
            _extractedText = result['fullText'];
            _issueDate = result['issueDate'];
            _expiryDate = result['expiryDate'];
          }
        });
        _animationController.forward();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Upload Document'),
        elevation: 0,
        backgroundColor: Colors.blue,
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
                        const Text('Select Document Type',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _documentType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.white,
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

                // Image Preview
                if (_image != null)
                  Card(
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
                                    const Text('Document Selected',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            : Image.file(_image as File, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Upload Button
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _pickAndScanDocument,
                  icon: Icon(_isProcessing ? Icons.hourglass_empty : Icons.camera_alt),
                  label: Text(
                    _isProcessing ? 'AI Scanning...' : 'Select & Scan with AI',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                          'AI is extracting dates...',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                // OCR Results
                if (_extractedText != null)
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
                        ElevatedButton.icon(
                          onPressed: () {
                            final newDoc = DocumentModel(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              userId: 'demo',
                              type: _documentType,
                              issueDate: _issueDate,
                              expiryDate: _expiryDate,
                              status: _expiryDate != null && _expiryDate!.isBefore(DateTime.now())
                                  ? 'Expired'
                                  : 'Valid',
                            );
                            context.read<DocumentProvider>().addDocument(newDoc);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text('Document saved successfully!'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                            Navigator.pop(context);
                          },
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
                      ],
                    ),
                  ),
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
    _ocrService.dispose();
    super.dispose();
  }
}
