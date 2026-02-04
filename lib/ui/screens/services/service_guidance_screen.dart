import 'package:flutter/material.dart';
import '../../../core/models/service.dart';

class ServiceGuidanceScreen extends StatelessWidget {
  final Service? service;

  const ServiceGuidanceScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final selectedService = service ?? Service.getServices().first;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedService.name),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              // TODO: Implement TTS for service description
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice narration coming soon!')),
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
            // Service Overview
            _buildServiceOverview(selectedService),

            const SizedBox(height: 30),

            // Eligibility Rules
            _buildEligibilitySection(selectedService),

            const SizedBox(height: 30),

            // Required Documents
            _buildDocumentsSection(selectedService),

            const SizedBox(height: 30),

            // Common Questions
            _buildQuestionsSection(selectedService),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOverview(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getServiceIcon(service.serviceId),
                  size: 40,
                  color: Colors.blue,
                ),
                const SizedBox(width: 15),
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
                        'Service Overview',
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(service.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilitySection(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eligibility Criteria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildEligibilityItem(
              'Caste Requirement',
              service.eligibilityRules['caste'] ?? 'Not specified',
            ),
            _buildEligibilityItem(
              'Income Limit',
              service.eligibilityRules['incomeLimit'] ?? 'Not specified',
            ),
            _buildEligibilityItem(
              'Education Level',
              service.eligibilityRules['educationLevel'] ?? 'Not specified',
            ),
            _buildEligibilityItem(
              'Age Limit',
              service.eligibilityRules['ageLimit'] ?? 'Not specified',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Required Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: service.requiredDocuments.length,
              itemBuilder: (context, index) {
                final document = service.requiredDocuments[index];
                return _buildDocumentItem(document, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection(Service service) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: service.commonQuestions.length,
              itemBuilder: (context, index) {
                final question = service.commonQuestions[index];
                return _buildQuestionItem(question, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 8, right: 15),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                index.toString(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(child: Text(document, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(String question, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '$index. $question',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer will be provided by the voice assistant or displayed here.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const Divider(height: 20),
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
