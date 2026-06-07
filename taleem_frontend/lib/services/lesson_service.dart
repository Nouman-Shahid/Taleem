import '../models/lesson.dart';
import 'api_client.dart';

class LessonService {
  static Future<List<Lesson>> listByType(String type) async {
    final res = await ApiClient.get('/lessons', query: {'type': type}) as Map<String, dynamic>;
    return ((res['lessons'] as List?) ?? const [])
        .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
