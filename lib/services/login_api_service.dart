import 'package:dio/dio.dart';

import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/models/login_models.dart';
import 'package:skillchain/services/api_service.dart';

/// API layer for login. Throws [ApiException] on error.
class LoginApiService {
  LoginApiService({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;

  static ApiException _fromDio(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = (data['message'] as String?) ?? message;
    }
    return ApiException(
      message: message,
      statusCode: statusCode,
      error: e.response?.data is Map
          ? (e.response?.data as Map)['error'] as String?
          : null,
    );
  }

  /// POST /users/login
  Future<LoginSuccessResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.post(
        '/users/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );
      final map = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      return LoginSuccessResponse.fromJson(map);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }
}
