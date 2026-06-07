import '../models/child.dart';
import 'api_client.dart';

class ChildService {
  static Future<List<Child>> list() async {
    final res = await ApiClient.get('/children') as Map<String, dynamic>;
    return ((res['children'] as List?) ?? const [])
        .map((e) => Child.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Child> create({
    required String name,
    required int age,
    required String gender,
  }) async {
    final res = await ApiClient.post('/children', body: {
      'name': name,
      'age': age,
      'gender': gender,
    }) as Map<String, dynamic>;
    return Child.fromJson(res['child'] as Map<String, dynamic>);
  }

  static Future<void> delete(int id) async {
    await ApiClient.delete('/children/$id');
  }
}
