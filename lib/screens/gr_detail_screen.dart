import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data' show Uint8List;
import '../widgets/global_voice_assistant.dart';

// Import html library for web functionality with stub for mobile
import '../utils/html_stub.dart'
    if (dart.library.html) 'dart:html' as html;
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

class GRDetailScreen extends StatelessWidget {
  final String title;
  final String pdfAsset;
  final String enSummary;
  final String hiSummary;
  final String mrSummary;

  const GRDetailScreen({
    super.key,
    required this.title,
    required this.pdfAsset,
    required this.enSummary,
    required this.hiSummary,
    required this.mrSummary,
  });

  Future<void> _launchPDF(BuildContext context) async {
    try {
      if (kIsWeb) {
        // For web, load the PDF bytes and create a data URL
        final bytes = await _loadPdfBytes(pdfAsset);
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Open in new tab
        html.window.open(url, '_blank');
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile, try to launch the PDF using the asset path
        try {
          // Try to get the file path for the asset
          final bytes = await _loadPdfBytes(pdfAsset);
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/document.pdf');
          await file.writeAsBytes(bytes);

          // Launch the PDF file
          if (await canLaunchUrl(Uri.file(file.path))) {
            await launchUrl(Uri.file(file.path));
          } else {
            _showPdfInDialog(context, pdfAsset);
          }
        } catch (e) {
          _showPdfInDialog(context, pdfAsset);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening PDF: $e')),
        );
      }
    }
  }

  Future<Uint8List> _loadPdfBytes(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  void _showPdfInDialog(BuildContext context, String pdfAsset) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PDF Document',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Icon(
                Icons.picture_as_pdf,
                size: 60,
                color: Colors.red.shade700,
              ),
              const SizedBox(height: 16),
              Text(
                'PDF: $pdfAsset',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
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
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _launchPDF(context),
            tooltip: 'View PDF',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PDF View Button Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () => _launchPDF(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade700, Colors.red.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'View Official GR Document',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to open PDF in viewer',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // English Summary
                _buildSummaryCard(
                  title: 'English Summary',
                  summary: enSummary,
                  icon: Icons.translate,
                  color: Colors.blue,
                  iconColor: Colors.blue.shade700,
                ),

                const SizedBox(height: 16),

                // Hindi Summary
                _buildSummaryCard(
                  title: 'Hindi Summary',
                  summary: hiSummary,
                  icon: Icons.translate,
                  color: Colors.orange,
                  iconColor: Colors.orange.shade700,
                ),

                const SizedBox(height: 16),

                // Marathi Summary
                _buildSummaryCard(
                  title: 'Marathi Summary',
                  summary: mrSummary,
                  icon: Icons.translate,
                  color: Colors.green,
                  iconColor: Colors.green.shade700,
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

  Widget _buildSummaryCard({
    required String title,
    required String summary,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                summary,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
