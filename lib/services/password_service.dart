import 'package:dio/dio.dart';
import 'package:skillchain/services/api_service.dart';

/// Handles forgot-password flow: send OTP, verify OTP, reset password.
/// Uses shared ApiService; endpoints are public (no auth header).
/// Never stores resetToken; never logs sensitive values.
class PasswordService {
  final ApiService _api = ApiService();

  /// Sends OTP to [email]. Throws [Exception] with backend message on failure.
  Future<void> forgotPassword(String email) async {
    try {
      await _api.post(
        '/users/forgot-password',
        data: <String, dynamic>{'email': email.trim()},
      );
    } on DioException catch (e) {
      final message = _messageFromResponse(e) ?? 'Something went wrong';
      throw Exception(message);
    }
  }

  /// Verifies OTP for [email]. Returns resetToken (do not store).
  /// Throws [Exception] with backend message on failure.
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await _api.post(
        '/users/verify-otp',
        data: <String, dynamic>{
          'email': email.trim(),
          'otp': otp.trim(),
        },
      );
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final token = data['resetToken'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Invalid response: no reset token');
      }
      return token;
    } on DioException catch (e) {
      final message = _messageFromResponse(e) ?? 'Something went wrong';
      throw Exception(message);
    }
  }

  /// Resets password using one-time [token] (from verify OTP step).
  /// Throws [Exception] with backend message on failure.
  Future<void> resetPassword(String token, String password) async {
    try {
      await _api.post(
        '/users/reset-password',
        data: <String, dynamic>{
          'token': token,
          'password': password,
        },
      );
    } on DioException catch (e) {
      final message = _messageFromResponse(e) ?? 'Something went wrong';
      throw Exception(message);
    }
  }

  static String? _messageFromResponse(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String) return msg;
    }
    return null;
  }
}
