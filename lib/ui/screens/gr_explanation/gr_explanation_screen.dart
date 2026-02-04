import 'package:flutter/material.dart';
import '../../../core/models/service.dart';

class GRExplanationScreen extends StatelessWidget {
  final Service? service;

  const GRExplanationScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final selectedService = service ?? Service.getServices().first;

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedService.name} - GR Explanation'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // TODO: Implement language switching
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Language switching coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Header
            _buildServiceHeader(selectedService),

            const SizedBox(height: 30),

            // GR Summary Section
            _buildGRSummarySection(selectedService),

            const SizedBox(height: 30),

            // Why This Document Needed
            _buildWhyNeededSection(selectedService),

            const SizedBox(height: 30),

            // Voice Narration
            _buildVoiceNarrationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              _getServiceIcon(service.serviceId),
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Government Rule Explanation',
                    style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGRSummarySection(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simplified GR Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // English Summary
            _buildLanguageSection('English', service.grSummary, Colors.blue),

            const SizedBox(height: 20),

            // Marathi Summary
            _buildLanguageSection(
              'Marathi',
              service.grSummaryMarathi,
              Colors.green,
            ),

            const SizedBox(height: 20),

            // Hindi Summary
            _buildLanguageSection(
              'Hindi',
              service.grSummaryHindi,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyNeededSection(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why This Document is Needed?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              'This document is required to verify your eligibility for the ${service.name} service. '
              'It helps the government authorities to ensure that benefits are provided to the '
              'right beneficiaries and prevents misuse of public funds.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            const Text(
              'Benefits of having this document:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBenefitItem('✓ Ensures eligibility verification'),
            _buildBenefitItem('✓ Prevents fraud and misuse'),
            _buildBenefitItem('✓ Streamlines application process'),
            _buildBenefitItem('✓ Enables digital processing'),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceNarrationSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voice Narration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'Listen to the explanation in your preferred language:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNarrationButton('English', Colors.blue, () {
                  // TODO: Implement TTS for English
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('English narration coming soon!'),
                    ),
                  );
                }),
                _buildNarrationButton('Marathi', Colors.green, () {
                  // TODO: Implement TTS for Marathi
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marathi narration coming soon!'),
                    ),
                  );
                }),
                _buildNarrationButton('Hindi', Colors.orange, () {
                  // TODO: Implement TTS for Hindi
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hindi narration coming soon!'),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(String language, String summary, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(summary, style: const TextStyle(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 10),
          Text(benefit, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNarrationButton(
    String language,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_up, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            language,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String serviceId) {
    switch (serviceId) {
      case 'obc_scholarship':
        return Icons.school;
      case 'driving_license':
        return Icons.directions_car;
      case 'income_certificate':
        return Icons.request_quote;
      default:
        return Icons.help;
    }
  }
}
