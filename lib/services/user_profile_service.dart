import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/services/api_service.dart';

class UserProfileService {
  UserProfileService({ApiService? apiService})
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

  /// PUT /users/profile - Update user profile (multipart/form-data)
  /// Returns the updated user object from the response (to persist and display).
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String bio,
    required int age,
    required String gender,
    required String location,
    required String phoneNumber,
    required String education,
    required List<String> offeringSkills,
    required List<String> learningSkills,
    required String pastExperience,
    File? profilePic,
    File? resume,
    File? portfolio,
    List<File> certificates = const [],
  }) async {
    final formData = FormData.fromMap({
      'fullName': fullName,
      'bio': bio,
      'age': age,
      'gender': gender,
      'location': location,
      'phoneNumber': phoneNumber,
      'education': education,
      'pastExperience': pastExperience,
    });
    for (final id in offeringSkills) {
      formData.fields.add(MapEntry('offeringSkills', id));
    }
    for (final id in learningSkills) {
      formData.fields.add(MapEntry('learningSkills', id));
    }

    if (profilePic != null && await profilePic.exists()) {
      formData.files.add(MapEntry(
        'profilePic',
        await MultipartFile.fromFile(profilePic.path),
      ));
    }
    if (resume != null && await resume.exists()) {
      formData.files.add(MapEntry(
        'resume',
        await MultipartFile.fromFile(resume.path),
      ));
    }
    if (portfolio != null && await portfolio.exists()) {
      formData.files.add(MapEntry(
        'portfolio',
        await MultipartFile.fromFile(portfolio.path),
      ));
    }
    for (final f in certificates) {
      if (await f.exists()) {
        formData.files.add(MapEntry(
          'certificate',
          await MultipartFile.fromFile(f.path),
        ));
      }
    }

    try {
      final res = await _api.putMultipart('/users/profile', data: formData);
      final map = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      final userJson = map['user'];
      if (userJson is! Map<String, dynamic>) {
        throw ApiException(message: 'Invalid response: missing user');
      }
      return userJson;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }
}
