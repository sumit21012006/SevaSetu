import 'package:flutter/material.dart';
import '../widgets/global_voice_assistant.dart';

class ServiceGuidanceScreen extends StatelessWidget {
  const ServiceGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Guidance')),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.work, size: 40, color: Colors.blue),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Tap to view details'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, '/service/$id'),
      ),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
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

    final service = services[serviceId];
    if (service == null) return Scaffold(body: Center(child: Text('Service not found')));

    final name = service['name'] as String;
    final eligibility = service['eligibility'] as String;
    final documents = service['documents'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Eligibility Rules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(eligibility),
              const SizedBox(height: 24),
              const Text('Required Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...documents.map((doc) => CheckboxListTile(
                    title: Text(doc),
                    value: false,
                    onChanged: (val) {},
                  )),
            ],
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }
}
