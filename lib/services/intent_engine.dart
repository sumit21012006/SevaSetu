class IntentResult {
  final String intent;
  final String? service;
  final double confidence;
  final List<String> missingInfo;
  final String? targetRoute;
  final String? response;
  final String? responseHi;
  final String? responseMr;

  IntentResult({
    required this.intent,
    this.service,
    required this.confidence,
    this.missingInfo = const [],
    this.targetRoute,
    this.response,
    this.responseHi,
    this.responseMr,
  });

  String getLocalizedResponse(String lang) {
    if (lang == 'hi' && responseHi != null) return responseHi!;
    if (lang == 'mr' && responseMr != null) return responseMr!;
    return response ?? '';
  }
}

class AgenticIntentEngine {
  IntentResult analyzeIntent(String text) {
    final lower = text.toLowerCase();
    final isHindi = _isHindiDevanagari(text);

    // Document vault intents
    if (_matchesAny(lower, ['document', 'vault', 'my documents', 'show documents', 'open vault', 
                            'dastavej', 'dastavez', 'mera dastavej', 'mera dastavez',
                            'dastavej dikhao', 'dastavez dikhao'])) {
      return IntentResult(
        intent: 'OPEN_DOCUMENTS',
        confidence: 0.95,
        targetRoute: '/documents',
        response: 'Opening your document vault',
        responseHi: 'आपका दस्तावेज वॉल्ट खोल रहा हूं',
        responseMr: 'तुमचे कागदपत्रे उघडत आहे',
      );
    }

    // Check validity/expired
    if (_matchesAny(lower, ['expired', 'validity', 'check validity', 'expiring',
                            'khatam', 'samapt', 'validity check', 'kharij hone vala'])) {
      return IntentResult(
        intent: 'CHECK_VALIDITY',
        confidence: 0.92,
        targetRoute: '/documents',
        response: 'Checking document validity',
        responseHi: 'दस्तावेज की वैधता जांच रहा हूं',
        responseMr: 'कागदपत्रांची वैधता तपासत आहे',
      );
    }

    // Scholarship service
    if (_matchesAny(lower, [
      'scholarship', 'apply scholarship', 'obc scholarship', 
      'scholarship ke liye apply', 'scholarship apply karu',
      'shishyavritti', 'shishyavritti ke liye',
      'shishyavritti RJ karaycha', 'shishyavritti lagnar',
      'shishkshalti', 'shishkshalti ke liye',
      'vittiya', 'vittiya yogyata', 'obc vitti',
      'last isha vritti', 'is scholarship', 'isha vritti',
      'apply for scholarship', 'i want scholarship', 'need scholarship',
      'scholarship application', 'scholarship form', 'scholarship apply',
    ])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'SCHOLARSHIP',
        confidence: 0.91,
        targetRoute: '/service/scholarship',
        response: 'Opening scholarship application service',
        responseHi: 'छात्रवृत्ति आवेदन सेवा खोल रहा हूं',
        responseMr: 'शिष्यवृत्ती अर्ज सेवा उघडत आहे',
      );
    }

    // Driving license
    if (_matchesAny(lower, ['license', 'driving license', 'driving licence', 'dl',
                            'driving licence ke liye apply', 'driving licence apply karu',
                            'driving', 'driving ka licence', 'vahan chalane ka licence',
                            'driving pramanpatra', 'vahan chalane ka pramanpatra'])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'DRIVING_LICENSE',
        confidence: 0.90,
        targetRoute: '/service/license',
        response: 'Opening driving license service',
        responseHi: 'ड्राइविंग लाइसेंस सेवा खोल रहा हूं',
        responseMr: 'ड्राइव्हिंग लाइसेंस सेवा उघडत आहे',
      );
    }

    // Income certificate
    if (_matchesAny(lower, ['income certificate', 'income cert', 'certificate',
                            'aamda ki tasdeek', 'tasdeek nama', 'amas',
                            'utsav pramanpatra', 'aamda pramanpatra'])) {
      return IntentResult(
        intent: 'OPEN_SERVICE',
        service: 'INCOME_CERTIFICATE',
        confidence: 0.88,
        targetRoute: '/service/income',
        response: 'Opening income certificate service',
        responseHi: 'आय प्रमाणपत्र सेवा खोल रहा हूं',
        responseMr: 'उत्पन्न प्रमाणपत्र सेवा उघडत आहे',
      );
    }

    // GR explanation
    if (_matchesAny(lower, ['gr', 'government rule', 'rule', 'explanation', 'policy',
                            'sarkari niyam', 'niyam', 'vidhhan', 'shasan aadesh',
                            'sarkari aadesh', 'mahamandal', 'shasan',
                            'show gr', 'show government', 'gr dikhao', 
                            'sarkari niyam dikhao', 'gr summary', 'gr details',
                            'obc scholarship gr', 'driving licence gr'])) {
      return IntentResult(
        intent: 'OPEN_GR',
        confidence: 0.85,
        targetRoute: '/gr',
        response: 'Opening government rule explanations',
        responseHi: 'सरकारी नियम समझाव खोल रहा हूं',
        responseMr: 'सरकारी नियम स्पष्टीकरण उघडत आहे',
      );
    }

    // Home
    if (_matchesAny(lower, ['home', 'dashboard', 'main screen', 
                            'ghar', 'ghar jana', 'home page',
                            'mukhya page', 'shuru'])) {
      return IntentResult(
        intent: 'GO_HOME',
        confidence: 0.95,
        targetRoute: '/home',
        response: 'Going to home',
        responseHi: 'होम पर जा रहा हूं',
        responseMr: 'होमवर जात आहे',
      );
    }

    // Services general
    if (_matchesAny(lower, ['service', 'apply', 'application', 'sewa',
                            'seva', 'apply karna', 'lagu karna',
                            'seva ke liye apply', 'yogyata'])) {
      return IntentResult(
        intent: 'OPEN_SERVICES',
        confidence: 0.75,
        targetRoute: '/services',
        response: 'Opening services',
        responseHi: 'सेवाएं खोल रहा हूं',
        responseMr: 'सेवा उघडत आहे',
      );
    }

    return IntentResult(
      intent: 'UNKNOWN',
      confidence: 0.3,
      response: 'I did not understand. Try saying: open my documents, apply for scholarship, or show government rules',
      responseHi: 'मुझे समझ नहीं आया। कोशिश करें: मेरे दस्तावेज खोलो, छात्रवृत्ति के लिए अर्ज करो, या सरकारी नियम दिखाओ',
      responseMr: 'समजल नाही. प्रयत्न करा: माझे कागदपत्रे उघडा, शिष्यवृत्तीसाठी अर्ज करा किंवा सरकारी नियम दाखवा',
    );
  }

  bool _matchesAny(String text, List<String> patterns) {
    return patterns.any((pattern) => text.contains(pattern));
  }

  bool _isHindiDevanagari(String text) {
    // Check for Hindi/Marathi Devanagari characters
    final devanagariRegex = RegExp(r'[\u0900-\u097F]');
    return devanagariRegex.hasMatch(text);
  }
}
