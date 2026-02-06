import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'intent_engine.dart';

class VoiceAgentController extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final AgenticIntentEngine _intentEngine = AgenticIntentEngine();
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isListening = false;
  String _transcript = '';
  bool _isInitialized = false;

  bool get isListening => _isListening;
  String get transcript => _transcript;

  VoiceAgentController(this.navigatorKey) {
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      _isInitialized = await _speech.initialize();
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
    } catch (e) {
      debugPrint('Voice init error: $e');
    }
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize();
      if (!_isInitialized) {
        _transcript = 'Microphone not available';
        notifyListeners();
        return;
      }
    }

    _isListening = true;
    _transcript = 'Listening...';
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _transcript = result.recognizedWords;
        notifyListeners();
        if (result.finalResult) {
          stopListening();
          _processCommand(_transcript);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  Future<void> _processCommand(String text) async {
    final intent = _intentEngine.analyzeIntent(text);

    if (intent.confidence < 0.6) {
      await _speak(intent.response ?? 'I did not understand');
      return;
    }

    if (intent.missingInfo.isNotEmpty) {
      await _speak('I need more information: ${intent.missingInfo.join(", ")}');
      return;
    }

    if (intent.targetRoute != null) {
      await _speak(intent.response ?? 'Navigating');
      navigatorKey.currentState?.pushNamed(intent.targetRoute!);
    }
  }

  void processManualCommand(String text) {
    _transcript = text;
    notifyListeners();
    _processCommand(text);
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    super.dispose();
  }
}
