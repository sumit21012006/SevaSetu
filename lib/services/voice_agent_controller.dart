import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'intent_engine.dart';

class VoiceAgentController extends ChangeNotifier {
	late SpeechToText _speech;
	final FlutterTts _tts = FlutterTts();
	final AgenticIntentEngine _intentEngine = AgenticIntentEngine();
	final GlobalKey<NavigatorState> navigatorKey;
	
	// For bottom navigation control
	int? _targetNavigationIndex;
	int? get targetNavigationIndex => _targetNavigationIndex;
	
	// Navigation callback for voice commands
	VoidCallback? _navigateCallback;

  bool _isListening = false;
  String _transcript = '';
  bool _isInitialized = false;
  String _errorMessage = '';
  String _responseText = '';
  String _detectedLanguage = 'en';

	bool get isListening => _isListening;
	String get transcript => _transcript;
	String get errorMessage => _errorMessage;
	String get responseText => _responseText;
	String get detectedLanguage => _detectedLanguage;

	VoiceAgentController(this.navigatorKey) {
		_speech = SpeechToText();
		_initServices();
	}

	Future<void> _initServices() async {
		try {
			_isInitialized = await _speech.initialize(
				onError: (error) {
					_errorMessage = error.errorMsg;
					debugPrint('Speech error: ${error.errorMsg}');
					notifyListeners();
				},
				onStatus: (status) {
					debugPrint('Speech status: $status');
					if (status == 'done' && _isListening) {
						_isListening = false;
						notifyListeners();
					}
				},
			);
			
			if (_isInitialized) {
				debugPrint('Speech recognition initialized');
			} else {
				_errorMessage = 'Speech recognition not available';
			}
			
			await _tts.setLanguage('en-US');
			await _tts.setSpeechRate(0.5);
		} catch (e) {
			debugPrint('Voice init error: $e');
			_errorMessage = e.toString();
			_isInitialized = false;
		}
		notifyListeners();
	}

	String _detectLanguage(String text) {
		// Check for Devanagari script (Hindi/Marathi) - definitive
		final devanagariRegex = RegExp(r'[\u0900-\u097F]');
		if (devanagariRegex.hasMatch(text)) {
			return 'hi'; // Hindi/Marathi
		}
		
		// Only detect as Hindi/Marathi if clearly Indian romanized words
		final lower = text.toLowerCase();
		
		// Hindi/Marathi specific words (NOT generic English)
		final indianPatterns = [
			// Hindi - clearly Hindi words
			'mujhe', 'mera', 'apna', 'karna', 'chahiye', 'ghar', 'sarkari', 'niyam',
			'ke liye', 'ko', 'se', 'ka', 'ki', 'kya', 'kaise', 'koi', 'laga',
			// Marathi - clearly Marathi words  
			'mala', 'majha', 'aahe', 'ahe', 'aahet', 'kay', 'kartaycha', 'lagnar',
			// Common Indian
			'dastavej', 'dastavez', 'dikhao', 'dikha',
			// Scholarship-related in Indian languages
			'shishyavritti', 'shishyavritti', 'shishkshalti',
			'vittiya', 'vitti', 'vritti', 
			// Other Indian
			'pramanpatra', 'tasdeek', 'tasdeek nama',
		];
		
		// Purely English common words that should NOT trigger Hindi
		final englishPatterns = [
			'i', 'want', 'need', 'apply', 'for', 'the', 'my', 'to', 'open',
			'document', 'documents', 'vault', 'show', 'display',
			'scholarship', 'scholarships', 'license', 'driving',
			'home', 'page', 'screen', 'service', 'services',
			'government', 'rule', 'rules', 'policy',
		];
		
		int indianMatchCount = 0;
		int englishMatchCount = 0;
		
		for (final pattern in indianPatterns) {
			if (lower.contains(pattern)) {
				indianMatchCount++;
			}
		}
		
		for (final pattern in englishPatterns) {
			if (lower.contains(pattern)) {
				englishMatchCount++;
			}
		}
		
		// If clearly more Indian words, detect as Hindi
		// But if mostly English, detect as English
		if (indianMatchCount >= 2 && indianMatchCount > englishMatchCount) {
			return 'hi';
		}
		
		return 'en';
	}

	Future<void> startListening() async {
		if (!_isInitialized) {
			_isInitialized = await _speech.initialize();
			if (!_isInitialized) {
				_transcript = 'Speech recognition not available. Please check microphone permissions.';
				_errorMessage = 'Not initialized';
				notifyListeners();
				return;
			}
		}

		_isListening = true;
		_transcript = 'Listening...';
		_responseText = '';
		_errorMessage = '';
		notifyListeners();

		try {
			await _speech.listen(
				onResult: (result) {
					debugPrint('Speech result: ${result.recognizedWords}, final: ${result.finalResult}');
					_transcript = result.recognizedWords;
					notifyListeners();
					
					if (result.finalResult) {
						// Auto-stop listening when final result detected
						_speech.cancel();
						_isListening = false;
						notifyListeners();
						if (_transcript.isNotEmpty) {
							_processCommand(_transcript);
						}
					}
				},
				listenFor: const Duration(seconds: 60),
				pauseFor: const Duration(seconds: 5),
				cancelOnError: false,
				partialResults: true,
			);
			debugPrint('Started listening...');
		} catch (e) {
			debugPrint('Speech listen error: $e');
			_isListening = false;
			_errorMessage = 'Error: $e';
			notifyListeners();
		}
	}

	Future<void> stopListening() async {
		try {
			await _speech.stop();
		} catch (e) {
			debugPrint('Speech stop error: $e');
		}
		_isListening = false;
		notifyListeners();
	}

	Future<void> _processCommand(String text) async {
		if (text.isEmpty) return;
		
		debugPrint('Processing command: $text');
		
		// Detect language
		_detectedLanguage = _detectLanguage(text);
		debugPrint('Detected language: $_detectedLanguage');
		
		final intent = _intentEngine.analyzeIntent(text);
		
		// Get localized response
		_responseText = intent.getLocalizedResponse(_detectedLanguage);
		notifyListeners();

		if (intent.confidence < 0.6) {
			await _speak(intent.getLocalizedResponse(_detectedLanguage));
			return;
		}

		if (intent.missingInfo.isNotEmpty) {
			await _speak(intent.getLocalizedResponse(_detectedLanguage));
			return;
		}

		if (intent.targetRoute != null) {
			debugPrint('Navigating to: ${intent.targetRoute}');
			await _speak(intent.getLocalizedResponse(_detectedLanguage));
			
			// Set target navigation index based on route
			_targetNavigationIndex = _getNavigationIndex(intent.targetRoute!);
			notifyListeners();
			
			// Trigger the navigation callback for HomeScreen to handle
			if (_navigateCallback != null) {
				await Future.delayed(const Duration(milliseconds: 300));
				_navigateCallback!();
			}
		} else {
			await _speak(intent.getLocalizedResponse(_detectedLanguage));
		}
	}

	int _getNavigationIndex(String route) {
		switch (route) {
			case '/home':
				return 0;
			case '/documents':
				return 1;
			case '/services':
				return 2;
			case '/gr':
				return 3;
			case '/profile':
				return 4;
			default:
				return 0;
		}
	}

	void clearNavigationTarget() {
		_targetNavigationIndex = null;
		notifyListeners();
	}

	void setNavigateCallback(VoidCallback callback) {
		_navigateCallback = callback;
	}

	void processManualCommand(String text) {
		_transcript = text;
		notifyListeners();
		_processCommand(text);
	}

	Future<void> _speak(String text) async {
		try {
			// Set TTS language and speed based on detected language
			if (_detectedLanguage == 'hi') {
				await _tts.setLanguage('hi-IN');
				await _tts.setSpeechRate(0.8); // Faster for Hindi
			} else if (_detectedLanguage == 'mr') {
				await _tts.setLanguage('mr-IN');
				await _tts.setSpeechRate(0.8); // Faster for Marathi
			} else {
				await _tts.setLanguage('en-US');
				await _tts.setSpeechRate(0.5);
			}
			await _tts.speak(text);
		} catch (e) {
			debugPrint('TTS error: $e');
		}
	}

	@override
	void dispose() {
		try {
			_speech.cancel();
			_tts.stop();
		} catch (e) {
			debugPrint('Dispose error: $e');
		}
		super.dispose();
	}
}
