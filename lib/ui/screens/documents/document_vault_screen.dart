import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/document.dart';

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Vault'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement document upload
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document upload coming soon!')),
              );
            },
          ),
        ],
      ),
      body: currentUser != null
          ? _buildDocumentList(context, currentUser.uid)
          : const Center(child: Text('Please sign in to view your documents')),
    );
  }

  Widget _buildDocumentList(BuildContext context, String userId) {
    // Mock documents for demo
    final mockDocuments = [
      Document(
        id: '1',
        userId: userId,
        fileName: 'Income Certificate.pdf',
        fileUrl: '',
        type: DocumentType.income,
        issueDate: DateTime(2024, 1, 15),
        expiryDate: DateTime(2025, 1, 15),
        status: DocumentStatus.expired,
        uploadedAt: DateTime.now(),
        notes: 'Annual income certificate',
      ),
      Document(
        id: '2',
        userId: userId,
        fileName: 'Aadhaar Card.pdf',
        fileUrl: '',
        type: DocumentType.aadhaar,
        issueDate: DateTime(2020, 5, 20),
        expiryDate: null,
        status: DocumentStatus.valid,
        uploadedAt: DateTime.now(),
        notes: 'Government issued ID',
      ),
      Document(
        id: '3',
        userId: userId,
        fileName: 'Caste Certificate.pdf',
        fileUrl: '',
        type: DocumentType.caste,
        issueDate: DateTime(2023, 8, 10),
        expiryDate: DateTime(2026, 8, 10),
        status: DocumentStatus.expiringSoon,
        uploadedAt: DateTime.now(),
        notes: 'OBC certificate',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: mockDocuments.length,
      itemBuilder: (context, index) {
        final document = mockDocuments[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(Document document) {
    Color statusColor;
    String statusText;

    switch (document.status) {
      case DocumentStatus.valid:
        statusColor = Colors.green;
        statusText = 'Valid';
        break;
      case DocumentStatus.expiringSoon:
        statusColor = Colors.orange;
        statusText = 'Expiring Soon';
        break;
      case DocumentStatus.expired:
        statusColor = Colors.red;
        statusText = 'Expired';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Document Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getDocumentIcon(document.type), color: Colors.blue),
            ),

            const SizedBox(width: 15),

            // Document Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.fileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    document.type.name.toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (document.expiryDate != null)
                        Text(
                          'Expires: ${_formatDate(document.expiryDate!)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    // TODO: View document
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Share document
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.income:
        return Icons.request_quote;
      case DocumentType.caste:
        return Icons.group;
      case DocumentType.aadhaar:
        return Icons.credit_card;
      case DocumentType.pan:
        return Icons.credit_card;
      case DocumentType.drivingLicense:
        return Icons.directions_car;
      case DocumentType.voterId:
        return Icons.how_to_vote;
      case DocumentType.rationCard:
        return Icons.local_grocery_store;
      case DocumentType.bankPassbook:
        return Icons.account_balance;
      case DocumentType.education:
        return Icons.school;
      default:
        return Icons.document_scanner;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
