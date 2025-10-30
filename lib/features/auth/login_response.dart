class LoginResponse {
  final bool status;
  final String? message;
  final String? accessToken;

  LoginResponse({
    required this.status,
    this.message,
    this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'],
      accessToken: json['access_token'],
    );
  }
}
