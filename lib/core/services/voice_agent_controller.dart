import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../models/service.dart';

class VoiceAgentController extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isProcessing = false;
  String _transcription = '';
  String _assistantResponse = '';

  VoiceAgentController() {
    _initTts();
  }

  bool get isListening => _isListening;
  bool get isProcessing => _isProcessing;
  String get transcription => _transcription;
  String get assistantResponse => _assistantResponse;

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-IN');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> startListening(BuildContext context) async {
    if (!_isListening && !_isProcessing) {
      _isListening = true;
      _transcription = '';
      _assistantResponse = '';
      notifyListeners();

      if (!_speechToText.isAvailable) {
        await _speechToText.initialize(
          onStatus: (status) => print('Speech status: $status'),
          onError: (error) => print('Speech error: $error'),
        );
      }

      await _speechToText.listen(
        onResult: (result) {
          _transcription = result.recognizedWords;
          notifyListeners();

          if (result.finalResult) {
            _stopListening();
            _processVoiceCommand(context, _transcription);
          }
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
      );
    }
  }

  Future<void> _stopListening() async {
    _isListening = false;
    await _speechToText.stop();
    notifyListeners();
  }

  Future<void> _processVoiceCommand(
    BuildContext context,
    String command,
  ) async {
    _isProcessing = true;
    _assistantResponse = 'Processing your request...';
    notifyListeners();

    try {
      final intentResult = await _analyzeIntent(command);
      await _handleIntent(context, intentResult);
    } catch (e) {
      _assistantResponse = 'I encountered an error. Please try again.';
      await _speakText(_assistantResponse);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _analyzeIntent(String command) async {
    command = command.toLowerCase().trim();

    // Intent recognition logic
    if (command.contains('apply') || command.contains('scholarship')) {
      return {
        'intent': 'OPEN_SERVICE',
        'service': 'OBC_SCHOLARSHIP',
        'confidence': 0.9,
        'missing_info': [],
        'target_route': '/service/obc_scholarship',
      };
    } else if (command.contains('driving') || command.contains('license')) {
      return {
        'intent': 'OPEN_SERVICE',
        'service': 'DRIVING_LICENSE',
        'confidence': 0.9,
        'missing_info': [],
        'target_route': '/service/driving_license',
      };
    } else if (command.contains('income') || command.contains('certificate')) {
      return {
        'intent': 'OPEN_SERVICE',
        'service': 'INCOME_CERTIFICATE',
        'confidence': 0.9,
        'missing_info': [],
        'target_route': '/service/income_certificate',
      };
    } else if (command.contains('document') || command.contains('vault')) {
      return {
        'intent': 'OPEN_DOCUMENT_VAULT',
        'confidence': 0.9,
        'target_route': '/documents',
      };
    } else if (command.contains('home') || command.contains('dashboard')) {
      return {
        'intent': 'OPEN_HOME',
        'confidence': 0.9,
        'target_route': '/home',
      };
    } else if (command.contains('help') || command.contains('guide')) {
      return {
        'intent': 'OPEN_SERVICE_GUIDANCE',
        'confidence': 0.8,
        'target_route': '/service_guidance',
      };
    } else if (command.contains('explain') || command.contains('what is')) {
      return {
        'intent': 'OPEN_GR_EXPLANATION',
        'confidence': 0.8,
        'target_route': '/gr_explanation',
      };
    } else {
      return {
        'intent': 'UNKNOWN',
        'confidence': 0.1,
        'suggestions': [
          'Try saying: "Apply for scholarship"',
          'Try saying: "Show my documents"',
          'Try saying: "What is driving license?"',
        ],
      };
    }
  }

  Future<void> _handleIntent(
    BuildContext context,
    Map<String, dynamic> intentResult,
  ) async {
    final intent = intentResult['intent'];
    final confidence = intentResult['confidence'];
    final targetRoute = intentResult['target_route'];

    if (confidence < 0.5) {
      // Low confidence - ask for clarification
      final suggestions = intentResult['suggestions'] as List<String>;
      _assistantResponse =
          'I didn\'t understand that clearly. Did you mean: ${suggestions.first}?';
      await _speakText(_assistantResponse);
      return;
    }

    switch (intent) {
      case 'OPEN_SERVICE':
        final serviceId = intentResult['service'];
        _assistantResponse = 'Opening $serviceId service page...';
        await _speakText(_assistantResponse);

        // Navigate to service page
        final navigationService = Provider.of<NavigationService>(
          context,
          listen: false,
        );
        navigationService.navigateTo(
          targetRoute,
          arguments: {'serviceId': serviceId},
        );
        break;

      case 'OPEN_DOCUMENT_VAULT':
        _assistantResponse = 'Opening your document vault...';
        await _speakText(_assistantResponse);

        final navigationService = Provider.of<NavigationService>(
          context,
          listen: false,
        );
        navigationService.navigateTo(targetRoute);
        break;

      case 'OPEN_HOME':
        _assistantResponse = 'Taking you to the home dashboard...';
        await _speakText(_assistantResponse);

        final navigationService = Provider.of<NavigationService>(
          context,
          listen: false,
        );
        navigationService.navigateTo(targetRoute);
        break;

      case 'OPEN_SERVICE_GUIDANCE':
        _assistantResponse = 'Opening service guidance...';
        await _speakText(_assistantResponse);

        final navigationService = Provider.of<NavigationService>(
          context,
          listen: false,
        );
        navigationService.navigateTo(targetRoute);
        break;

      case 'OPEN_GR_EXPLANATION':
        _assistantResponse = 'Opening government rule explanation...';
        await _speakText(_assistantResponse);

        final navigationService = Provider.of<NavigationService>(
          context,
          listen: false,
        );
        navigationService.navigateTo(targetRoute);
        break;

      default:
        _assistantResponse =
            'I\'m not sure how to help with that. Please try a different command.';
        await _speakText(_assistantResponse);
    }
  }

  Future<void> _speakText(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  void reset() {
    _isListening = false;
    _isProcessing = false;
    _transcription = '';
    _assistantResponse = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
