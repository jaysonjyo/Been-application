import 'package:dio/dio.dart';
class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://beechem.ishtech.live/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  // login
  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    return await _dio.post(endpoint, data: FormData.fromMap(data ?? {}));
  }

// personnel list
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? params, String? token}) async {
    return await _dio.get(
      endpoint,
      queryParameters: params,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }
  // personnel adding
  Future<Response> postWithToken(
      String endpoint, {
        required String token,
        required Map<String, dynamic> data,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            "Content-Type": "application/x-www-form-urlencoded"
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      // Optional: log or handle structured error
      throw Exception('POST request failed: ${e.message}');
    }
  }

}
