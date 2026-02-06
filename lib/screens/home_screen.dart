import 'package:flutter/material.dart';
import '../widgets/global_voice_assistant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SevaSetu Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () => _showVoiceHelp(context)),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildVoiceIntroCard(context),
              const SizedBox(height: 16),
              _buildQuickServiceCard(context, 'Document Vault', Icons.folder, '/documents', Colors.blue),
              _buildQuickServiceCard(context, 'Service Guidance', Icons.work, '/services', Colors.green),
              _buildQuickServiceCard(context, 'GR Explanation', Icons.description, '/gr', Colors.orange),
            ],
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildVoiceIntroCard(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.mic, size: 50, color: Colors.blue),
            const SizedBox(height: 12),
            const Text('Voice Assistant Ready', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Tap the mic button and say:\n"Open my documents" or "Apply for scholarship"',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServiceCard(BuildContext context, String title, IconData icon, String route, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  void _showVoiceHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Commands'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• "Open my documents"'),
            Text('• "Apply for scholarship"'),
            Text('• "Check document validity"'),
            Text('• "Show government rules"'),
            Text('• "Go to home"'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
