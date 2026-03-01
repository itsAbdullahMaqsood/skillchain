import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/models/skill_post_dto.dart';
import 'package:skillchain/models/skill_post.dart';
import 'package:skillchain/services/api_service.dart';

/// Service for skill post operations.
/// POST /skill-posts — create.
/// GET /skill-posts — paginated feed.
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
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> payload) async {
    try {
      final res = await _api.post('/skill-posts', data: payload);
      final data = res.data;
      if (data is Map<String, dynamic>) return data;
      return {'success': true};
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// GET /skill-posts?limit=&offset=&status=&search=
  /// Returns a [PaginatedSkillPosts] domain object.
  /// 401 is handled by the auth interceptor (refresh / logout).
  Future<PaginatedSkillPosts> getSkillPosts({
    required int limit,
    required int offset,
    required String status,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': limit,
        'offset': offset,
        'status': status,
      };
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      debugPrint('[SkillPostService] GET /skill-posts?$queryParameters');
      final res = await _api.get(
        '/skill-posts',
        queryParameters: queryParameters,
      );
      final data = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      debugPrint('[SkillPostService] Response total=${data['total']} hasMore=${data['hasMore']} posts=${(data['posts'] as List?)?.length ?? 0}');
      final dto = PaginatedSkillPostsDto.fromJson(data);
      return SkillPostMapper.fromPaginatedDto(dto);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// GET /skill-posts/my-posts?limit=&offset=
  /// Returns the current user's own posts as a [PaginatedSkillPosts].
  Future<PaginatedSkillPosts> getMyPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };
      debugPrint('[SkillPostService] GET /skill-posts/my-posts?$queryParameters');
      final res = await _api.get(
        '/skill-posts/my-posts',
        queryParameters: queryParameters,
      );
      final data = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      debugPrint('[SkillPostService] my-posts total=${data['total']} hasMore=${data['hasMore']} posts=${(data['posts'] as List?)?.length ?? 0}');
      final dto = PaginatedSkillPostsDto.fromJson(data);
      return SkillPostMapper.fromPaginatedDto(dto);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }
}
