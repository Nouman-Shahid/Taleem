import 'package:flutter/foundation.dart';
import '../models/progress_summary.dart';
import 'api_client.dart';

class ProgressService {
  static Future<void> log({
    required int childId,
    required String moduleType,
    required int score,
    required int total,
  }) async {
    try {
      await ApiClient.post('/progress', body: {
        'child_id': childId,
        'module_type': moduleType,
        'score': score,
        'total': total,
      });
    } catch (e) {
      debugPrint('[ProgressService.log] FAILED: $e');
      rethrow;
    }
  }

  static Future<ProgressSummary> summary(int childId) async {
    final res = await ApiClient.get('/progress/$childId/summary') as Map<String, dynamic>;
    final overall = (res['overall'] as Map<String, dynamic>?) ?? const {};
    return ProgressSummary.fromJson(overall);
  }
}
