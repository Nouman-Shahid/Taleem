import '../models/child.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthResult {
  final AppUser user;
  final String token;
  final List<Child> children;

  AuthResult({required this.user, required this.token, required this.children});
}

class AuthService {
  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await ApiClient.post('/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    }) as Map<String, dynamic>;

    return AuthResult(
      user: AppUser.fromJson(res['user'] as Map<String, dynamic>),
      token: res['token'] as String,
      children: const [],
    );
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiClient.post('/login', body: {
      'email': email,
      'password': password,
    }) as Map<String, dynamic>;

    return AuthResult(
      user: AppUser.fromJson(res['user'] as Map<String, dynamic>),
      token: res['token'] as String,
      children: const [],
    );
  }

  static Future<AuthResult> me() async {
    final res = await ApiClient.get('/me') as Map<String, dynamic>;
    final children = ((res['children'] as List?) ?? const [])
        .map((e) => Child.fromJson(e as Map<String, dynamic>))
        .toList();
    return AuthResult(
      user: AppUser.fromJson(res['user'] as Map<String, dynamic>),
      token: '',
      children: children,
    );
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post('/logout');
    } catch (_) {
      // ignore — we still clear local session
    }
  }
}
