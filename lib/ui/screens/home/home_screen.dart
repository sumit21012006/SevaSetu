import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/voice_agent_controller.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/models/service.dart';
import '../../widgets/voice_assistant_overlay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final voiceAgent = Provider.of<VoiceAgentController>(context);
    final navigationService = Provider.of<NavigationService>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SevaSetu Home'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildHomeContent(context, navigationService),

          // Global Microphone Button (Floating)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                _showVoiceAssistant(context);
              },
              backgroundColor: Colors.blue,
              child: Icon(
                voiceAgent.isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    NavigationService navigationService,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(context),

          const SizedBox(height: 30),

          // Quick Services
          const Text(
            'Quick Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _buildServiceGrid(navigationService),

          const SizedBox(height: 30),

          // Document Readiness
          _buildDocumentReadinessCard(context),

          const SizedBox(height: 20),

          // Voice Assistant Info
          _buildVoiceAssistantInfoCard(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to SevaSetu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your voice-first civic intelligence assistant. Tap the microphone button to start.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 10),
                const Text(
                  'Try saying: "Apply for scholarship" or "Show my documents"',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid(NavigationService navigationService) {
    final services = MockServices.getServices();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              navigationService.navigateTo(
                '/service/${service.serviceId}',
                arguments: {'service': service},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getServiceIcon(service.serviceId),
                    size: 40,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentReadinessCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder, color: Colors.green),
                const SizedBox(width: 10),
                const Text(
                  'Document Vault',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Provider.of<NavigationService>(
                      context,
                      listen: false,
                    ).navigateTo('/documents');
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Keep your documents organized and track their validity status.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatusIndicator('Valid', Colors.green, 5),
                const SizedBox(width: 20),
                _buildStatusIndicator('Expiring', Colors.orange, 2),
                const SizedBox(width: 20),
                _buildStatusIndicator('Expired', Colors.red, 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceAssistantInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up, color: Colors.blue),
                const SizedBox(width: 10),
                const Text(
                  'Voice Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Your digital seva kendra operator. It listens, thinks, asks clarifying questions, and guides you.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            const Text(
              'Available commands:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '• "Apply for scholarship"\n• "Check my documents"\n• "What is driving license?"\n• "Show expired documents"',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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

  void _showVoiceAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceAssistantOverlay(),
    );
  }
}
