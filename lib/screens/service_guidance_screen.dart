import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/global_voice_assistant.dart';
import '../services/document_provider.dart';
import '../models/models.dart';

// Helper functions shared between screens
Map<String, List<String>> _checkDocumentStatuses(List<String> requiredDocs, DocumentProvider docProvider) {
  final available = <String>[];
  final expired = <String>[];
  final missing = <String>[];

  for (final requiredDoc in requiredDocs) {
    DocumentModel? doc;
    try {
      doc = docProvider.documents.firstWhere(
        (d) => d.type.toLowerCase().contains(requiredDoc.toLowerCase().split(' ').first) ||
                requiredDoc.toLowerCase().contains(d.type.toLowerCase().split(' ').first),
      );
    } catch (e) {
      // Document not found
    }

    if (doc != null) {
      if (doc.status == 'Expired') {
        expired.add(doc.type);
      } else {
        available.add(doc.type);
      }
    } else {
      missing.add(requiredDoc);
    }
  }

  return {
    'available': available,
    'expired': expired,
    'missing': missing,
  };
}

Map<String, dynamic> _getServiceInfo(String serviceId) {
  final services = {
    'scholarship': {
      'name': 'OBC Scholarship',
      'eligibility': 'Family income < 8 lakhs, OBC category, Age 18-25',
      'documents': ['Income Certificate', 'Caste Certificate', 'Aadhaar Card', 'Bank Passbook'],
    },
    'license': {
      'name': 'Driving License',
      'eligibility': 'Age 18+, Valid learner license, Passed driving test',
      'documents': ['Aadhaar Card', 'Address Proof', 'Age Proof', 'Passport Photo', 'Learner License'],
    },
    'income': {
      'name': 'Income Certificate',
      'eligibility': 'Resident of state, Valid address proof',
      'documents': ['Aadhaar Card', 'Ration Card', 'Salary Slip', 'Property Documents'],
    },
  };
  return services[serviceId] ?? {};
}

class ServiceGuidanceScreen extends StatefulWidget {
  const ServiceGuidanceScreen({super.key});

  @override
  State<ServiceGuidanceScreen> createState() => _ServiceGuidanceScreenState();
}

class _ServiceGuidanceScreenState extends State<ServiceGuidanceScreen> {
  @override
  void initState() {
    super.initState();
    // Check if opened with arguments from voice navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _showServiceDetail(args);
      }
    });
  }

  void _showServiceDetail(String serviceId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailScreen(serviceId: serviceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Guidance'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildServiceCard(context, 'OBC Scholarship', 'scholarship'),
              _buildServiceCard(context, 'Driving License', 'license'),
              _buildServiceCard(context, 'Income Certificate', 'income'),
            ],
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String name, String id) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.work, size: 32, color: Colors.blue),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: const Text('Tap to view details and document status'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () => _showServiceDetail(id),
      ),
    );
  }
}

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? _editingDocType;

  @override
  Widget build(BuildContext context) {
    final service = _getServiceInfo(widget.serviceId);
    if (service.isEmpty) return Scaffold(body: Center(child: Text('Service not found')));

    final name = service['name'] as String;
    final eligibility = service['eligibility'] as String;
    final documents = service['documents'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Consumer<DocumentProvider>(
            builder: (context, docProvider, _) {
              final documentStatuses = _checkDocumentStatuses(documents, docProvider);
              
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Eligibility Card
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
                              Icon(Icons.verified_user, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              const Text('Eligibility Rules', 
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(eligibility, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Document Status Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (documentStatuses['missing']?.isEmpty ?? true) &&
                                (documentStatuses['expired']?.isEmpty ?? true)
                            ? [Colors.green.shade100, Colors.green.shade50]
                            : [Colors.orange.shade100, Colors.orange.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (documentStatuses['missing']?.isEmpty ?? true) &&
                                      (documentStatuses['expired']?.isEmpty ?? true)
                                  ? Icons.check_circle 
                                  : Icons.warning,
                              size: 40,
                              color: (documentStatuses['missing']?.isEmpty ?? true) &&
                                      (documentStatuses['expired']?.isEmpty ?? true)
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              (documentStatuses['missing']?.isEmpty ?? true) &&
                                      (documentStatuses['expired']?.isEmpty ?? true)
                                  ? 'Ready to Apply!' 
                                  : 'Action Required',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (documentStatuses['missing']?.isEmpty ?? true) &&
                                        (documentStatuses['expired']?.isEmpty ?? true)
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${documentStatuses['available']?.length ?? 0} of ${documents.length} documents ready',
                          style: TextStyle(
                            fontSize: 14,
                            color: (documentStatuses['missing']?.isEmpty ?? true) &&
                                    (documentStatuses['expired']?.isEmpty ?? true)
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Available Documents Section
                  if ((documentStatuses['available']?.isNotEmpty ?? false)) ...[
                    _buildDocSection(
                      '✅ Available Documents',
                      documentStatuses['available']!,
                      Colors.green,
                      context,
                      docProvider,
                      showActions: false,
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Expired Documents Section - WITH UPDATE OPTION
                  if ((documentStatuses['expired']?.isNotEmpty ?? false)) ...[
                    _buildDocSectionWithAction(
                      '⚠️ Expired - Needs Renewal',
                      documentStatuses['expired']!,
                      Colors.red,
                      context,
                      docProvider,
                      actionLabel: 'Update Document',
                      actionColor: Colors.red.shade600,
                      onAction: (docName) {
                        _showUpdateDialog(context, docProvider, docName);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Missing Documents Section - WITH UPLOAD OPTION
                  if ((documentStatuses['missing']?.isNotEmpty ?? false)) ...[
                    _buildDocSectionWithAction(
                      '❌ Missing Documents',
                      documentStatuses['missing']!,
                      Colors.grey,
                      context,
                      docProvider,
                      actionLabel: 'Upload Document',
                      actionColor: Colors.blue.shade600,
                      onAction: (docName) {
                        Navigator.pushNamed(context, '/upload');
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: (documentStatuses['missing']?.isEmpty ?? true) &&
                              (documentStatuses['expired']?.isEmpty ?? true)
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Proceeding with application...')),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.send),
                      label: const Text('Apply Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // Space for voice assistant
                ],
              );
            },
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildDocSection(String title, List<String> docs, Color color, BuildContext context, 
      DocumentProvider docProvider, {bool showActions = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(color == Colors.green ? Icons.check_circle 
                   : color == Colors.red ? Icons.warning 
                   : Icons.error, 
                   color: color),
              const SizedBox(width: 8),
              Text(title, 
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: color == Colors.green ? Colors.green.shade800
                       : color == Colors.red ? Colors.red.shade800
                       : Colors.grey.shade700,
                )),
            ],
          ),
          const SizedBox(height: 12),
          ...docs.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.description, size: 20, color: color.withOpacity(0.7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(doc, 
                    style: TextStyle(
                      fontSize: 14,
                      color: color == Colors.green ? Colors.green.shade700
                           : color == Colors.red ? Colors.red.shade700
                           : Colors.grey.shade600,
                    )),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDocSectionWithAction(
    String title, 
    List<String> docs, 
    Color color, 
    BuildContext context,
    DocumentProvider docProvider, {
    required String actionLabel,
    required Color actionColor,
    required Function(String) onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(color == Colors.green ? Icons.check_circle 
                   : color == Colors.red ? Icons.warning 
                   : Icons.error, 
                   color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: color == Colors.green ? Colors.green.shade800
                         : color == Colors.red ? Colors.red.shade800
                         : Colors.grey.shade700,
                  )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...docs.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.description, size: 20, color: color.withOpacity(0.7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(doc, 
                    style: TextStyle(
                      fontSize: 14,
                      color: color == Colors.green ? Colors.green.shade700
                           : color == Colors.red ? Colors.red.shade700
                           : Colors.grey.shade600,
                    )),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => onAction(doc),
                  icon: Icon(color == Colors.red ? Icons.refresh : Icons.upload, size: 16),
                  label: Text(actionLabel, style: const TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, DocumentProvider docProvider, String docName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $docName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text('This will update your $docName with a new valid document.'),
            const SizedBox(height: 8),
            const Text('Upload a new document to replace the expired one.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/upload');
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload New'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
