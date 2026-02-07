import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<Map<String, dynamic>> extractDocumentInfo(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final fullText = recognizedText.text;
      final issueDate = _extractDate(fullText, ['issue', 'issued', 'date of issue']);
      final expiryDate = _extractDate(fullText, ['expiry', 'valid until', 'expires', 'valid till']);

      return {
        'success': true,
        'fullText': fullText,
        'issueDate': issueDate,
        'expiryDate': expiryDate,
      };
    } catch (e) {
      debugPrint('OCR Error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  DateTime? _extractDate(String text, List<String> keywords) {
    final lines = text.split('\n');
    
    for (var line in lines) {
      final lowerLine = line.toLowerCase();
      if (keywords.any((keyword) => lowerLine.contains(keyword))) {
        // Try multiple date formats
        final datePatterns = [
          RegExp(r'(\d{2})[/-](\d{2})[/-](\d{4})'), // DD/MM/YYYY or DD-MM-YYYY
          RegExp(r'(\d{4})[/-](\d{2})[/-](\d{2})'), // YYYY/MM/DD or YYYY-MM-DD
          RegExp(r'(\d{2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d{4})'), // DD Mon YYYY
        ];

        for (var pattern in datePatterns) {
          final match = pattern.firstMatch(line);
          if (match != null) {
            try {
              if (pattern == datePatterns[0]) {
                // DD/MM/YYYY
                final day = int.parse(match.group(1)!);
                final month = int.parse(match.group(2)!);
                final year = int.parse(match.group(3)!);
                return DateTime(year, month, day);
              } else if (pattern == datePatterns[1]) {
                // YYYY/MM/DD
                final year = int.parse(match.group(1)!);
                final month = int.parse(match.group(2)!);
                final day = int.parse(match.group(3)!);
                return DateTime(year, month, day);
              }
            } catch (e) {
              debugPrint('Date parse error: $e');
            }
          }
        }
      }
    }
    return null;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
