import 'dart:convert';
import 'package:http/http.dart' as http;
import '../state/app_session.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? body;

  ApiException(this.statusCode, this.message, [this.body]);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static const String baseUrl = 'https://adelina-inconceivable-alysa.ngrok-free.dev/api';

  static const Duration _timeout = Duration(seconds: 20);

  static Map<String, String> _headers({bool json = true}) {
    final h = <String, String>{
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': '1',
    };
    if (json) h['Content-Type'] = 'application/json';
    final token = AppSession.instance.token;
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  static Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await http.get(uri, headers: _headers(json: false)).timeout(_timeout);
    return _decode(res);
  }

  static Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http
        .post(uri, headers: _headers(), body: body == null ? null : jsonEncode(body))
        .timeout(_timeout);
    return _decode(res);
  }

  static Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.delete(uri, headers: _headers()).timeout(_timeout);
    return _decode(res);
  }

  static dynamic _decode(http.Response res) {
    final raw = res.body.isEmpty ? null : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return raw;
    }
    final msg = (raw is Map && raw['message'] is String)
        ? raw['message'] as String
        : 'Request failed (${res.statusCode})';
    throw ApiException(res.statusCode, msg, raw is Map<String, dynamic> ? raw : null);
  }
}
