import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_agent_controller.dart';

class GlobalVoiceAssistant extends StatelessWidget {
  const GlobalVoiceAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Consumer<VoiceAgentController>(
        builder: (context, voice, _) {
          return FloatingActionButton(
            heroTag: 'voice',
            backgroundColor: voice.isListening ? Colors.red : Colors.blue,
            onPressed: () {
              if (voice.isListening) {
                voice.stopListening();
              } else {
                voice.startListening();
              }
            },
            child: Icon(voice.isListening ? Icons.mic : Icons.mic_none),
          );
        },
      ),
    );
  }
}
