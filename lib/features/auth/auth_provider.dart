import 'package:flutter/foundation.dart';
import 'auth_repository.dart';
import 'login_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  bool loading = false;
  String? error;
  String? accessToken; // ✅ store token here

  AuthProvider(this._repo);

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final LoginResponse res = await _repo.login(email, password);

      loading = false;
      notifyListeners();

      if (res.status) {
        accessToken = res.accessToken; // ✅ assign token
        if (kDebugMode) {
          print("✅ Login Success | Token: $accessToken");
        }
        return true;
      } else {
        error = res.message ?? 'Login failed. Please check your credentials.';
        if (kDebugMode) {
          print("⚠️ Login failed: $error");
        }
        return false;
      }
    } catch (e) {
      loading = false;
      error = 'Network error: $e';
      notifyListeners();
      if (kDebugMode) {
        print("❌ Exception: $e");
      }
      return false;
    }
  }
}
