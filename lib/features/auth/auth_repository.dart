import '../../core/api_client.dart';
import '../../core/storage.dart';
import 'login_response.dart';


class AuthRepository {
  final ApiClient _api = ApiClient();
  final SecureStorage _storage = SecureStorage();

  Future<LoginResponse> login(String email, String password) async {
    final res = await _api.post('login', data: {
      'email': email,
      'password': password,
      'mob_user': '1',
    });
    final data = LoginResponse.fromJson(res.data);
    if (data.status && data.accessToken != null) {
      await _storage.saveToken(data.accessToken!);
    }
    return data;
  }
}
