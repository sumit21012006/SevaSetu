import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/voice_agent_controller.dart';

class VoiceAssistantOverlay extends StatelessWidget {
  const VoiceAssistantOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final voiceAgent = Provider.of<VoiceAgentController>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Voice Assistant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Status Indicator
            _buildStatusIndicator(voiceAgent),

            const SizedBox(height: 20),

            // Transcription Display
            _buildTranscriptionDisplay(voiceAgent),

            const SizedBox(height: 20),

            // Assistant Response
            _buildAssistantResponse(voiceAgent),

            const SizedBox(height: 30),

            // Action Buttons
            _buildActionButtons(context, voiceAgent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(VoiceAgentController voiceAgent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: voiceAgent.isListening
                ? Colors.green
                : voiceAgent.isProcessing
                ? Colors.orange
                : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          voiceAgent.isListening
              ? 'Listening...'
              : voiceAgent.isProcessing
              ? 'Processing...'
              : 'Ready to listen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: voiceAgent.isListening
                ? Colors.green
                : voiceAgent.isProcessing
                ? Colors.orange
                : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptionDisplay(VoiceAgentController voiceAgent) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: voiceAgent.transcription.isNotEmpty
          ? Text(
              voiceAgent.transcription,
              style: const TextStyle(fontSize: 16, height: 1.5),
            )
          : const Text(
              'Say something to get started...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }

  Widget _buildAssistantResponse(VoiceAgentController voiceAgent) {
    if (voiceAgent.assistantResponse.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        voiceAgent.assistantResponse,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    VoiceAgentController voiceAgent,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: voiceAgent.isListening || voiceAgent.isProcessing
              ? null
              : () {
                  voiceAgent.startListening(context);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Row(
            children: [
              Icon(
                voiceAgent.isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                voiceAgent.isListening ? 'Stop' : 'Start Listening',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
