// Typed request/response for login flow.

class LoginRequest {
  LoginRequest({required this.email, required this.password});
  final String email;
  final String password;
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginSuccessResponse {
  LoginSuccessResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
  final Map<String, dynamic> user;
  final String accessToken;
  final String refreshToken;

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return LoginSuccessResponse(
      user: user is Map<String, dynamic>
          ? Map<String, dynamic>.from(user)
          : <String, dynamic>{},
      accessToken: (json['accessToken'] as String?) ?? '',
      refreshToken: (json['refreshToken'] as String?) ?? '',
    );
  }
}
