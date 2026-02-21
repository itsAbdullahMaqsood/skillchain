import 'package:dio/dio.dart';

import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/services/api_service.dart';

/// POST /skill-posts — create a new skill post.
/// Throws [ApiException] on error.
class SkillPostService {
  SkillPostService({ApiService? apiService})
      : _api = apiService ?? ApiService();

  final ApiService _api;

  static ApiException _fromDio(DioException e) {
    final data = e.response?.data;
    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = (data['message'] as String?) ?? message;
    }
    return ApiException(
      message: message,
      statusCode: e.response?.statusCode,
      error: data is Map ? (data['error'] as String?) : null,
    );
  }

  /// POST /skill-posts with the given payload.
  /// Returns the response data map on success.
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> payload) async {
    try {
      final res = await _api.post('/skill-posts', data: payload);
      final data = res.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'success': true};
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }
}
