import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/html_stub.dart'
    if (dart.library.html) 'dart:html' as html;
import '../widgets/global_voice_assistant.dart';
import '../services/document_provider.dart';
import '../models/models.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  void _showDocumentPreview(DocumentModel doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Document Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: doc.isPdf
                        ? Colors.purple.shade100
                        : Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    doc.isPdf ? Icons.picture_as_pdf : Icons.description,
                    size: 50,
                    color: doc.isPdf
                        ? Colors.purple.shade700
                        : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Document Name
              Text(
                doc.type,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (doc.fileName != null)
                Text(
                  doc.fileName!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              // Document Details
              _buildDetailRow(Icons.calendar_today, 'Issue Date',
                  _formatDate(doc.issueDate)),
              _buildDetailRow(
                  Icons.event, 'Expiry Date', _formatDate(doc.expiryDate)),
              _buildDetailRow(
                Icons.check_circle,
                'Status',
                doc.status,
                valueColor: doc.status == 'Expired' ? Colors.red : Colors.green,
              ),
              _buildDetailRow(
                Icons.category,
                'Type',
                doc.isPdf ? 'PDF Document' : 'Image Document',
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _openInExternalViewer(doc);
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            doc.isPdf ? Colors.purple : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _downloadDocument(doc);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    bool isDark = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openInExternalViewer(DocumentModel doc) async {
    try {
      if (kIsWeb) {
        // For web, show the document in a dialog
        if (doc.isPdf) {
          // For PDFs on web, show a message
          _showPdfWebMessage(doc);
        } else {
          // For images on web, show in full screen dialog
          _showImagePreview(doc);
        }
      } else {
        // For mobile
        if (doc.filePath != null && doc.filePath!.isNotEmpty) {
          final file = File(doc.filePath!);
          if (await file.exists()) {
            // Try to open with default app
            if (doc.isPdf) {
              await launchUrl(Uri.file(file.absolute.path));
            } else {
              _showImagePreview(doc);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File not found'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file path available'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadDocument(DocumentModel doc) async {
    try {
      if (kIsWeb) {
        // For web, trigger download from base64 or data URI
        if (doc.imageData != null && doc.imageData!.isNotEmpty) {
          // Create a data URI and trigger download
          final bytes = base64Decode(doc.imageData!);
          final blob = html.Blob([bytes], 'image/png');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', '${doc.type}.png')
            ..click();
          html.Url.revokeObjectUrl(url);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text('Downloaded: ${doc.fileName ?? doc.type}')),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else if (doc.filePath != null && doc.filePath!.startsWith('data:')) {
          // Handle data URI
          final dataUri = doc.filePath!;
          final parts = dataUri.split(',');
          final bytes = base64Decode(parts[1]);
          final blob = html.Blob([bytes], 'image/png');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', '${doc.type}.png')
            ..click();
          html.Url.revokeObjectUrl(url);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text('Downloaded: ${doc.fileName ?? doc.type}')),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No document data available to download'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // For mobile, save to file
        if (doc.filePath != null && doc.filePath!.isNotEmpty) {
          final file = File(doc.filePath!);
          if (await file.exists()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Saved: ${file.path}')),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File not found'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImagePreview(DocumentModel doc) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black87,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doc.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Display the actual image if available
                              if (doc.imageData != null &&
                                  doc.imageData!.isNotEmpty)
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 300,
                                    maxWidth: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      base64Decode(doc.imageData!),
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 80,
                                            color: Colors.blue.shade400,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else if (doc.filePath != null &&
                                  doc.filePath!.startsWith('data:'))
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 300,
                                    maxWidth: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      doc.filePath!,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 80,
                                            color: Colors.blue.shade400,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.blue.shade400,
                                ),
                              const SizedBox(height: 20),
                              Text(
                                'Document: ${doc.fileName ?? doc.type}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                Icons.calendar_today,
                                'Issue Date',
                                _formatDate(doc.issueDate),
                                isDark: true,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                Icons.event,
                                'Expiry Date',
                                _formatDate(doc.expiryDate),
                                isDark: true,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: doc.status == 'Expired'
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Status: ${doc.status}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPdfWebMessage(DocumentModel doc) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: Colors.red.shade700,
              ),
              const SizedBox(height: 20),
              Text(
                doc.fileName ?? doc.type,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'PDF Document - ${doc.status}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                Icons.calendar_today,
                'Issue Date',
                _formatDate(doc.issueDate),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.event,
                'Expiry Date',
                _formatDate(doc.expiryDate),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Document Vault'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Consumer<DocumentProvider>(
            builder: (context, docProvider, _) {
              final documents = docProvider.documents;

              if (documents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('No documents yet',
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text('Tap + to add your first document',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  final isExpired = doc.status == 'Expired';
                  final isPdf = doc.isPdf;

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _showDocumentPreview(doc),
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: isExpired
                                  ? [Colors.red.shade50, Colors.white]
                                  : isPdf
                                      ? [Colors.purple.shade50, Colors.white]
                                      : [Colors.green.shade50, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? Colors.red.shade100
                                    : isPdf
                                        ? Colors.purple.shade100
                                        : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isPdf
                                    ? Icons.picture_as_pdf
                                    : Icons.description,
                                size: 32,
                                color: isExpired
                                    ? Colors.red.shade700
                                    : isPdf
                                        ? Colors.purple.shade700
                                        : Colors.green.shade700,
                              ),
                            ),
                            title: Text(doc.type,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                if (doc.isPdf && doc.fileName != null)
                                  Row(
                                    children: [
                                      Icon(Icons.insert_drive_file,
                                          size: 14,
                                          color: Colors.purple.shade600),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          doc.fileName!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.purple.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (doc.isPdf && doc.fileName != null)
                                  const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text('Issue: ${_formatDate(doc.issueDate)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.event,
                                        size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                        'Expiry: ${doc.expiryDate != null ? _formatDate(doc.expiryDate) : "No Expiry"}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? Colors.red.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                doc.status,
                                style: TextStyle(
                                  color: isExpired
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/upload'),
        icon: const Icon(Icons.add),
        label: const Text('Add Document'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
