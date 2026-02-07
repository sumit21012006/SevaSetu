import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              _buildDetailRow(Icons.calendar_today, 'Issue Date', _formatDate(doc.issueDate)),
              _buildDetailRow(Icons.event, 'Expiry Date', _formatDate(doc.expiryDate)),
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
                        backgroundColor: doc.isPdf ? Colors.purple : Colors.blue,
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

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openInExternalViewer(DocumentModel doc) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(doc.isPdf ? Icons.picture_as_pdf : Icons.image, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Opening ${doc.fileName ?? doc.type}...'),
            ),
          ],
        ),
        backgroundColor: doc.isPdf ? Colors.purple : Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      Icon(Icons.folder_open, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('No documents yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text('Tap + to add your first document',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                isPdf ? Icons.picture_as_pdf : Icons.description,
                                size: 32,
                                color: isExpired 
                                    ? Colors.red.shade700 
                                    : isPdf 
                                        ? Colors.purple.shade700 
                                        : Colors.green.shade700,
                              ),
                            ),
                            title: Text(doc.type,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                if (doc.isPdf && doc.fileName != null)
                                  Row(
                                    children: [
                                      Icon(Icons.insert_drive_file, size: 14, color: Colors.purple.shade600),
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
                                if (doc.isPdf && doc.fileName != null) const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text('Issue: ${_formatDate(doc.issueDate)}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.event, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text('Expiry: ${doc.expiryDate != null ? _formatDate(doc.expiryDate) : "No Expiry"}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isExpired ? Colors.red.shade100 : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                doc.status,
                                style: TextStyle(
                                  color: isExpired ? Colors.red.shade700 : Colors.green.shade700,
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
