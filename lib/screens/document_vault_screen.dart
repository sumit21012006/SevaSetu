import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/global_voice_assistant.dart';
import '../services/document_provider.dart';

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});

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
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(opacity: value, child: child),
                      );
                    },
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
                              color: isExpired ? Colors.red.shade100 : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.description,
                              size: 32,
                              color: isExpired ? Colors.red.shade700 : Colors.green.shade700,
                            ),
                          ),
                          title: Text(doc.type,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
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
