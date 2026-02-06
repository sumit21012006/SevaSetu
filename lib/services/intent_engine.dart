import 'package:flutter/foundation.dart';

class IntentResult {
  final String intent;
  final String? service;
  final double confidence;
  final List<String> missingInfo;
  final String? targetRoute;
  final String? response;

  IntentResult({
    required this.intent,
    this.service,
    required this.confidence,
    this.missingInfo = const [],
    this.targetRoute,
    this.response,
  });
}

class AgenticIntentEngine {
  IntentResult analyzeIntent(String text) {
    final lower = text.toLowerCase();

    // Document vault intents
    if (_matchesAny(lower, ['document', 'vault', 'my documents', 'show documents', 'open vault'])) {
      return IntentResult(
        intent: 'OPEN_DOCUMENTS',
        confidence: 0.95,
        targetRoute: '/documents',
        response: 'Opening your document vault',
      );
    }

    // Check validity/expired
    if (_matchesAny(lower, ['expired', 'validity', 'check validity', 'expiring'])) {
      return IntentResult(
        intent: 'CHECK_VALIDITY',
        confidence: 0.92,
        targetRoute: '/documents',
        response: 'Checking document validity',
      );
    }

    // Scholarship service
    if (_matchesAny(lower, ['scholarship', 'apply scholarship', 'obc scholarship'])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'SCHOLARSHIP',
        confidence: 0.91,
        targetRoute: '/service/scholarship',
        response: 'Opening scholarship application service',
      );
    }

    // Driving license
    if (_matchesAny(lower, ['license', 'driving license', 'driving licence', 'dl'])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'DRIVING_LICENSE',
        confidence: 0.90,
        targetRoute: '/service/license',
        response: 'Opening driving license service',
      );
    }

    // Income certificate
    if (_matchesAny(lower, ['income certificate', 'income cert', 'certificate'])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'INCOME_CERTIFICATE',
        confidence: 0.88,
        targetRoute: '/service/income',
        response: 'Opening income certificate service',
      );
    }

    // GR explanation
    if (_matchesAny(lower, ['gr', 'government rule', 'rule', 'explanation', 'policy'])) {
      return IntentResult(
        intent: 'OPEN_GR',
        confidence: 0.85,
        targetRoute: '/gr',
        response: 'Opening government rule explanations',
      );
    }

    // Home
    if (_matchesAny(lower, ['home', 'dashboard', 'main screen'])) {
      return IntentResult(
        intent: 'GO_HOME',
        confidence: 0.95,
        targetRoute: '/home',
        response: 'Going to home',
      );
    }

    // Services general
    if (_matchesAny(lower, ['service', 'apply', 'application'])) {
      return IntentResult(
        intent: 'OPEN_SERVICES',
        confidence: 0.75,
        targetRoute: '/services',
        response: 'Opening services',
      );
    }

    return IntentResult(
      intent: 'UNKNOWN',
      confidence: 0.3,
      response: 'I did not understand. Try saying: open my documents, apply for scholarship, or show government rules',
    );
  }

  bool _matchesAny(String text, List<String> patterns) {
    return patterns.any((pattern) => text.contains(pattern));
  }
}
