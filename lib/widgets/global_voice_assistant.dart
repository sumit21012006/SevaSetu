import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_agent_controller.dart';

class GlobalVoiceAssistant extends StatelessWidget {
  const GlobalVoiceAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'keyboard',
            mini: true,
            backgroundColor: Colors.green,
            onPressed: () => _showManualInput(context),
            child: const Icon(Icons.keyboard, size: 20),
          ),
          const SizedBox(height: 8),
          Consumer<VoiceAgentController>(
            builder: (context, voice, _) {
              return FloatingActionButton(
                heroTag: 'voice',
                backgroundColor: voice.isListening ? Colors.red : Colors.blue,
                onPressed: () {
                  if (voice.isListening) {
                    voice.stopListening();
                  } else {
                    voice.startListening();
                    _showVoiceOverlay(context);
                  }
                },
                child: Icon(voice.isListening ? Icons.mic : Icons.mic_none),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showManualInput(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Type Command'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'e.g., open my documents',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Try:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const Text('• open my documents', style: TextStyle(fontSize: 11)),
            const Text('• apply for scholarship', style: TextStyle(fontSize: 11)),
            const Text('• check document validity', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<VoiceAgentController>().processManualCommand(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Execute'),
          ),
        ],
      ),
    );
  }

  void _showVoiceOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 280,
        child: Column(
          children: [
            const Icon(Icons.mic, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Listening...', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Try: "Open my documents" or "Apply for scholarship"',
                style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<VoiceAgentController>(
                builder: (context, voice, _) => SingleChildScrollView(
                  child: Text(
                    voice.transcript.isEmpty ? 'Speak now...' : voice.transcript,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<VoiceAgentController>().stopListening();
                Navigator.pop(context);
              },
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    ).then((_) => context.read<VoiceAgentController>().stopListening());
  }
}
