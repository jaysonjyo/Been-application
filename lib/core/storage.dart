import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async =>
      await _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() async =>
      await _storage.read(key: _tokenKey);

  Future<void> clearToken() async =>
      await _storage.delete(key: _tokenKey);
}
