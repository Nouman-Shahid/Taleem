import 'package:flutter/foundation.dart';
import 'api_client.dart';

class ImlaService {
  static Future<void> storeAttempt({
    required int childId,
    required String targetLetter,
    String? predictedLetter,
    required double confidence,
    required bool isCorrect,
    required String language,
  }) async {
    try {
      await ApiClient.post('/imla/attempts', body: {
        'child_id': childId,
        'target_letter': targetLetter,
        'predicted_letter': predictedLetter,
        'confidence': confidence,
        'is_correct': isCorrect,
        'language': language,
      });
    } catch (e) {
      debugPrint('[ImlaService.storeAttempt] FAILED: $e');
      rethrow;
    }
  }
}
