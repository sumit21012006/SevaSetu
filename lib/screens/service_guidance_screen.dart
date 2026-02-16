import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/html_stub.dart'
    if (dart.library.html) 'dart:html' as html;
import '../widgets/global_voice_assistant.dart';
import '../services/document_provider.dart';
import '../models/models.dart';

class ServiceGuidanceScreen extends StatefulWidget {
  const ServiceGuidanceScreen({super.key});

  @override
  State<ServiceGuidanceScreen> createState() => _ServiceGuidanceScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final service = _getServiceInfo(widget.serviceId);
    if (service.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Service Not Found'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: Text('Service not found')),
      );
    }

    final name = service['name'] as String;
    final eligibility = service['eligibility'] as List<dynamic>;
    final benefits = service['benefits'] as List<dynamic>;
    final documents = service['documents'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Consumer<DocumentProvider>(
            builder: (context, docProvider, _) {
              final documentStatuses =
                  _checkDocumentStatuses(documents, docProvider);
              final totalDocs = documents.length;
              final availableDocs = documentStatuses['available']?.length ?? 0;
              final progress =
                  totalDocs > 0 ? (availableDocs / totalDocs).toDouble() : 0.0;
              final progressPercentage = (progress * 100).toInt();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Progress Card with Circular Indicator
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Document Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular progress background
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            // Circular progress indicator
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                            // Percentage text
                            Column(
                              children: [
                                Text(
                                  '$progressPercentage%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$availableDocs/$totalDocs',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Documents Section
                  _buildDocumentsSection(
                    context,
                    docProvider,
                    documents,
                    documentStatuses,
                  ),
                  const SizedBox(height: 24),

                  // Download ZIP Button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadDocumentsZip(
                          context, docProvider, documents),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        'Download All Documents (ZIP)',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Eligibility Section
                  _buildSectionCard(
                    'Eligibility Criteria',
                    Icons.verified_user,
                    Colors.green,
                    eligibility.map((item) => '• $item').toList(),
                  ),
                  const SizedBox(height: 16),

                  // Benefits Section
                  _buildSectionCard(
                    'Benefits',
                    Icons.star,
                    Colors.orange,
                    benefits.map((item) => '• $item').toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              );
            },
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      String title, IconData icon, Color color, List<String> items) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700]!,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection(
    BuildContext context,
    DocumentProvider docProvider,
    List<dynamic> documents,
    Map<String, List<String>> documentStatuses,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.blue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blue, size: 24),
                SizedBox(width: 12),
                Text(
                  'Required Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: documents.asMap().entries.map((entry) {
                final index = entry.key;
                final docName = entry.value.toString();
                final isAvailable =
                    documentStatuses['available']?.contains(docName) ?? false;
                final isExpired =
                    documentStatuses['expired']?.contains(docName) ?? false;

                return _buildDocumentCard(
                  context,
                  docProvider,
                  docName,
                  index + 1,
                  isAvailable,
                  isExpired,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    DocumentProvider docProvider,
    String docName,
    int number,
    bool isAvailable,
    bool isExpired,
  ) {
    Color cardColor;
    Color textColor;
    IconData statusIcon;
    String statusText;

    if (isAvailable) {
      cardColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green[700]!;
      statusIcon = Icons.check_circle;
      statusText = 'Available';
    } else if (isExpired) {
      cardColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange[700]!;
      statusIcon = Icons.warning;
      statusText = 'Expired';
    } else {
      cardColor = Colors.grey.withOpacity(0.1);
      textColor = Colors.grey[700]!;
      statusIcon = Icons.error;
      statusText = 'Missing';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Number Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: textColor.withOpacity(0.5)),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Document Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(statusIcon, size: 16, color: textColor),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          ElevatedButton.icon(
            onPressed: () {
              if (isAvailable) {
                _showDocumentDetails(context, docProvider, docName);
              } else {
                _showUploadBottomSheet(context, docName);
              }
            },
            icon: Icon(
              isAvailable ? Icons.visibility : Icons.upload,
              size: 16,
              color: Colors.white,
            ),
            label: Text(
              isAvailable ? 'View' : 'Upload',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(
      BuildContext context, DocumentProvider docProvider, String docName) {
    final document = docProvider.documents.firstWhere(
      (doc) => doc.type == docName,
      orElse: () => DocumentModel(
        id: '',
        userId: docProvider.currentUserId ?? '',
        type: docName,
        filePath: '',
        status: 'Missing',
        expiryDate: null,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.type),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${document.status}'),
            if (document.expiryDate != null)
              Text('Expiry: ${document.expiryDate}'),
            Text('Uploaded: ${document.createdAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUploadBottomSheet(BuildContext context, String docName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 16,
          right: 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Document',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Document: $docName'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUploadOption(
                  context,
                  'Upload from Gallery',
                  Icons.image,
                  Colors.blue,
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/upload', arguments: {
                      'documentType': docName,
                      'isPdfMode': false,
                    });
                  },
                ),
                _buildUploadOption(
                  context,
                  'Upload PDF',
                  Icons.picture_as_pdf,
                  Colors.red,
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/upload', arguments: {
                      'documentType': docName,
                      'isPdfMode': true,
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _downloadDocumentsZip(BuildContext context, DocumentProvider docProvider,
      List<dynamic> documents) async {
    try {
      final archive = Archive();
      int fileCount = 0;

      // Add each document to the archive
      for (final docName in documents) {
        final document = docProvider.documents.firstWhere(
          (doc) => doc.type == docName.toString(),
          orElse: () => DocumentModel(
            id: '',
            userId: docProvider.currentUserId ?? '',
            type: docName.toString(),
            filePath: '',
            status: 'Missing',
            expiryDate: null,
          ),
        );

        if (document.filePath != null &&
            document.filePath!.isNotEmpty &&
            document.status != 'Missing') {
          try {
            late List<int> fileBytes;

            if (kIsWeb) {
              // For web, we need to handle differently
              final response = await rootBundle.load(document.filePath!);
              fileBytes = response.buffer.asUint8List();
            } else {
              // For mobile, read from file system
              final file = File(document.filePath!);
              if (await file.exists()) {
                fileBytes = await file.readAsBytes();
                archive.addFile(ArchiveFile(
                  document.type,
                  fileBytes.length,
                  fileBytes,
                ));
                fileCount++;
              }
            }
          } catch (e) {
            print('Error reading file ${document.filePath}: $e');
          }
        }
      }

      if (fileCount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No documents available for download')),
        );
        return;
      }

      // Create ZIP data
      final zipData = ZipEncoder().encode(archive);
      final zipBytes = zipData!;

      if (kIsWeb) {
        // Web download
        final blob = html.Blob([zipBytes], 'application/zip');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..download = 'documents_${DateTime.now().millisecondsSinceEpoch}.zip'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Mobile download
        final directory = await getApplicationDocumentsDirectory();
        final zipFile = File(
            '${directory.path}/documents_${DateTime.now().millisecondsSinceEpoch}.zip');
        await zipFile.writeAsBytes(zipBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ZIP file saved to ${zipFile.path}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating ZIP file: $e')),
      );
    }
  }
}

class _ServiceGuidanceScreenState extends State<ServiceGuidanceScreen> {
  @override
  void initState() {
    super.initState();
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
              _buildServiceCard(
                  context, 'OBC Tution Fee Waiver Scheme', 'scholarship'),
              _buildServiceCard(
                  context, 'Driving License Application', 'license'),
              _buildServiceCard(context, 'Income Certificate', 'income'),
              _buildServiceCard(
                  context, 'Bank Account Opening', 'bank_account'),
              _buildServiceCard(context, 'Ladki Bahin Yojana', 'ladki_bahin'),
              _buildServiceCard(
                  context, 'Ration Card Application', 'ration_card'),
              _buildServiceCard(context, 'PAN Card Application', 'pan_card'),
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
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: const Text('Tap to view details and document status'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () => _showServiceDetail(id),
      ),
    );
  }
}

// Helper functions
Map<String, List<String>> _checkDocumentStatuses(
    List<dynamic> requiredDocs, DocumentProvider docProvider) {
  final available = <String>[];
  final expired = <String>[];
  final missing = <String>[];

  for (final requiredDoc in requiredDocs) {
    DocumentModel? doc;
    try {
      doc = docProvider.documents.firstWhere(
        (d) =>
            d.type.toLowerCase().contains(
                requiredDoc.toString().toLowerCase().split(' ').first) ||
            requiredDoc
                .toString()
                .toLowerCase()
                .contains(d.type.toLowerCase().split(' ').first),
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
      missing.add(requiredDoc.toString());
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
      'eligibility': [
        'Family income less than 8 lakhs per annum',
        'Must belong to OBC category as per government records',
        'Age between 18-25 years',
        'Must be pursuing higher education (graduation/post-graduation)',
        'Must have valid Aadhaar card and bank account',
      ],
      'benefits': [
        'Full tuition fee reimbursement for eligible courses',
        'Monthly maintenance allowance of ₹1,000',
        'Book grant of ₹5,000 per academic year',
        'One-time computer grant of ₹15,000',
        'Hostel facility with subsidized rates',
        'Priority in government job recruitment',
      ],
      'documents': [
        'Mahadbt Application Form',
        'MHT-CET Result',
        'SSC Marksheet',
        'HSC Marksheet',
        'B-Tech Marksheet (Renewal)',
        'HSC LC',
        'Income Certificate',
        'Non-Creamy Layer',
        'Nationality & Domicile Certificate',
        'Caste Certificate',
        'Caste Validity',
        'Aadhaar Card',
        'Undertaking',
      ],
    },
    'license': {
      'name': 'Driving License',
      'eligibility': [
        'Minimum age of 18 years for LMV vehicles',
        'Must hold a valid learner\'s license',
        'Must pass the driving test conducted by RTO',
        'Must be a resident of Maharashtra state',
        'No disqualification from holding a license',
      ],
      'benefits': [
        'Legal authorization to drive motor vehicles',
        'Valid identity proof for various purposes',
        'Required for vehicle insurance and registration',
        'Eligibility for international driving permit',
        'Access to online driving-related services',
        'Lifetime validity for non-commercial licenses',
      ],
      'documents': [
        'Address Proof',
        'Age Proof',
        'Passport Photo',
        'Learner License',
      ],
    },
    'income': {
      'name': 'Income Certificate',
      'eligibility': [
        'Must be a resident of Maharashtra state',
        'Must provide valid address proof documents',
        'Must submit family income details and proof',
        'Self-employed individuals need business registration',
        'Salaried individuals need salary slips and employment proof',
      ],
      'benefits': [
        'Required for scholarship applications',
        'Needed for educational institution admissions',
        'Eligibility for government welfare schemes',
        'Required for tax exemption certificates',
        'Access to concessional loans and financial aid',
        'Valid for one financial year from date of issue',
      ],
      'documents': [
        'Ration Card',
        'Salary Slip',
        'Property Documents',
      ],
    },
    'bank_account': {
      'name': 'Bank Account Opening',
      'eligibility': [
        'Minimum age of 18 years (10 years for minor accounts with guardian)',
        'Must be an Indian resident or NRI (with different account types)',
        'Must provide valid identity and address proof',
        'No criminal record or blacklisting by banks',
        'Must comply with KYC (Know Your Customer) norms',
      ],
      'benefits': [
        'Access to digital banking services and mobile banking',
        'Direct benefit transfers (DBT) for government schemes',
        'Interest on deposits (savings account)',
        'Easy fund transfers and online payments',
        'Access to credit facilities and loans',
        'Financial inclusion and security of money',
        'Pradhan Mantri Jan Dhan Yojana benefits for eligible accounts',
      ],
      'documents': [
        'Aadhaar Card',
        'PAN Card',
        'Passport Size Photograph',
        'Address Proof (Electricity Bill, Ration Card, etc.)',
        'Identity Proof (Voter ID, Driving License, etc.)',
        'Signature Proof',
        'Nominee Details',
      ],
    },
    'ladki_bahin': {
      'name': 'Ladki Bahin Yojana',
      'eligibility': [
        'Must be a female resident of Maharashtra state',
        'Age between 18-60 years',
        'Family income should be below poverty line or specified limit',
        'Must not be receiving similar benefits from other schemes',
        'Priority given to single women, widows, and differently-abled women',
      ],
      'benefits': [
        'Monthly financial assistance of ₹1,500',
        'Priority in government employment opportunities',
        'Free education and skill development programs',
        'Health insurance coverage under state schemes',
        'Subsidized housing and loan facilities',
        'Legal aid and counseling services',
        'Support for entrepreneurship and self-employment',
      ],
      'documents': [
        'Aadhaar Card',
        'Ration Card',
        'Income Certificate',
        'Residence Certificate',
        'Bank Passbook/Account Details',
        'Passport Size Photograph',
        'Caste Certificate (if applicable)',
        'Disability Certificate (if applicable)',
      ],
    },
    'ration_card': {
      'name': 'Ration Card Application',
      'eligibility': [
        'Must be a resident of Maharashtra state',
        'Family members must be Indian citizens',
        'No existing ration card in the family name',
        'Must provide proof of residence and identity',
        'Priority for BPL (Below Poverty Line) families',
      ],
      'benefits': [
        'Subsidized food grains (wheat, rice, sugar, pulses)',
        'Access to public distribution system (PDS)',
        'Eligibility for various government welfare schemes',
        'Priority in employment and housing schemes',
        'Financial assistance during emergencies',
        'Access to healthcare and education benefits',
      ],
      'documents': [
        'Aadhaar Card',
        'Residence Proof',
        'Identity Proof',
        'Family Details (Birth certificates, Marriage certificate)',
        'Income Certificate (for BPL card)',
        'Passport Size Photographs',
        'Bank Account Details',
      ],
    },
    'pan_card': {
      'name': 'PAN Card Application',
      'eligibility': [
        'All Indian citizens and residents',
        'Minors can apply with guardian details',
        'Foreign citizens with Indian income sources',
        'Companies, firms, and organizations',
        'No age restrictions',
      ],
      'benefits': [
        'Mandatory for financial transactions above ₹50,000',
        'Required for income tax filing',
        'Essential for opening bank accounts',
        'Needed for property and vehicle registration',
        'Required for investment in stocks and mutual funds',
        'Identity proof for various government and private services',
      ],
      'documents': [
        'Proof of Identity (Aadhaar, Voter ID, etc.)',
        'Proof of Address (Aadhaar, Utility Bill, etc.)',
        'Proof of Date of Birth (Birth Certificate, etc.)',
        'Passport Size Photograph',
        'Father\'s Name (mandatory for all applicants)',
        'Mother\'s Name (optional)',
      ],
    },
  };
  return services[serviceId] ?? {};
}

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}
