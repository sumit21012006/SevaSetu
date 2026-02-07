import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_agent_controller.dart';
import '../widgets/global_voice_assistant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final voice = context.read<VoiceAgentController>();
      voice.setNavigateCallback(() {
        if (mounted) {
          _handleVoiceNavigation();
        }
      });
    });
  }

  void _handleVoiceNavigation() {
    final voice = context.read<VoiceAgentController>();
    final route = voice.responseText;
    
    // First, pop any open routes to get back to MainScreen
    Navigator.of(context).popUntil((route) => route.isFirst);
    
    if (route.contains('scholarship')) {
      // Navigate to Services tab first, then push scholarship detail
      Navigator.of(context)
          .pushNamed('/services', arguments: 'scholarship')
          .then((_) {
        // After returning from services, ensure we're on the right tab
        voice.clearNavigationTarget();
      });
    } else if (route.contains('license') || route.contains('driving')) {
      Navigator.of(context)
          .pushNamed('/services', arguments: 'license')
          .then((_) {
        voice.clearNavigationTarget();
      });
    } else if (route.contains('income') || route.contains('certificate')) {
      Navigator.of(context)
          .pushNamed('/services', arguments: 'income')
          .then((_) {
        voice.clearNavigationTarget();
      });
    } else if (route.contains('document') || route.contains('vault')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/documents');
    } else if (route.contains('gr') || route.contains('rule') || route.contains('government')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/gr');
    } else if (route.contains('service') || route.contains('services')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/services');
    }
    
    // Clear navigation target to avoid tab switching after detail screen closes
    voice.clearNavigationTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.blue.shade800],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'SevaSetu',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your Gateway to Government Services',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Voice Interface
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<VoiceAgentController>(
                            builder: (context, voice, _) {
                              return GestureDetector(
                                onTap: () => voice.startListening(),
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: voice.isListening 
                                          ? [Colors.red.shade600, Colors.red.shade400]
                                          : [Colors.blue.shade600, Colors.blue.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (voice.isListening ? Colors.red : Colors.blue)
                                            .withOpacity(0.4),
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        voice.isListening ? Icons.stop : Icons.mic,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        voice.isListening ? 'Listening...' : 'Tap to Speak',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Transcript
                          Consumer<VoiceAgentController>(
                            builder: (context, voice, _) {
                              if (voice.transcript.isEmpty || 
                                  voice.transcript == 'Listening...') {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 32),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '"${voice.transcript}"',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    if (voice.responseText.isNotEmpty) ...[
                                      const Divider(height: 16),
                                      Text(
                                        voice.responseText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Hint Text
                          Text(
                            'Try: "Show GR" or "Open documents"',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const GlobalVoiceAssistant(),
          ],
        ),
      ),
    );
  }
}
