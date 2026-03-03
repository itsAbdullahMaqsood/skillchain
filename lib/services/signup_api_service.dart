import 'dart:io';

import 'package:dio/dio.dart';

import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/models/signup_models.dart';
import 'package:skillchain/services/api_service.dart';

/// API layer for signup flow: verify email, verify OTP, final signup (multipart).
/// All methods throw [ApiException] on error.
class SignupApiService {
  SignupApiService({ApiService? apiService})
      : _api = apiService ?? ApiService();

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
      error: e.response?.data is Map ? (e.response?.data['error'] as String?) : null,
    );
  }

  /// POST /users/verify-email
  Future<VerifyEmailResponse> verifyEmail(String email) async {
    try {
      final res = await _api.post(
        '/users/verify-email',
        data: VerifyEmailRequest(email: email).toJson(),
      );
      return VerifyEmailResponse.fromJson(
        res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : {},
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// POST /users/verify-otp-signup
  Future<VerifyOtpSignupResponse> verifyOtpSignup({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await _api.post(
        '/users/verify-otp-signup',
        data: VerifyOtpSignupRequest(email: email, otp: otp).toJson(),
      );
      final map = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      return VerifyOtpSignupResponse.fromJson(map);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// POST /users/signup (multipart/form-data)
  Future<SignupSuccessResponse> signup({
    required String token,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required int age,
    required String gender,
    required String location,
    required String offeringSkills,
    required String learningSkills,
    String? education,
    String? pastExperience,
    File? profilePic,
    File? portfolio,
    File? resume,
    List<File> certificate = const [],
  }) async {
    final formData = FormData.fromMap({
      'token': token,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'location': location,
      'offeringSkills': offeringSkills,
      'learningSkills': learningSkills,
      if (education != null && education.isNotEmpty) 'education': education,
      if (pastExperience != null && pastExperience.isNotEmpty)
        'pastExperience': pastExperience,
    });
    if (profilePic != null && await profilePic.exists()) {
      formData.files.add(MapEntry(
        'profilePic',
        await MultipartFile.fromFile(profilePic.path),
      ));
    }
    if (portfolio != null && await portfolio.exists()) {
      formData.files.add(MapEntry(
        'portfolio',
        await MultipartFile.fromFile(portfolio.path),
      ));
    }
    if (resume != null && await resume.exists()) {
      formData.files.add(MapEntry(
        'resume',
        await MultipartFile.fromFile(resume.path),
      ));
    }
    for (final f in certificate) {
      if (await f.exists()) {
        formData.files.add(MapEntry(
          'certificate',
          await MultipartFile.fromFile(f.path),
        ));
      }
    }

    try {
      final res = await _api.postMultipart('/users/signup', data: formData);
      final map = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      return SignupSuccessResponse.fromJson(map);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// GET /skills - returns skills from backend for learning/offering dropdowns.
  /// Response: { "skills": [{ "_id", "name", "description", "category", ... }], "total", "limit", "offset", "hasMore" }
  Future<List<SkillItem>> getSkills() async {
    try {
      final res = await _api.get('/skills/active-skills');
      final data = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      final list = data['skills'];
      if (list is! List) return [];
      return List<dynamic>.from(list)
          .map((e) => SkillItem.fromJson(
              e is Map<String, dynamic> ? e : <String, dynamic>{}))
          .toList();
    } on DioException catch (_) {
      return [];
    }
  }
}
