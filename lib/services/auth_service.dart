import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skillchain/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  // Signup
  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    String? bio,
    int? age,
    String? gender,
    String? location,
    String? phoneNumber,
    String? education,
    List<String>? offeringSkills,
    List<String>? learningSkills,
    String? pastExperience,
    String? portfolioLink,
  }) async {
    try {
      print('Attempting signup to: ${ApiService.baseUrl}/users/signup');

      // Prepare the request data
      final requestData = <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'password': password,
        if (bio != null && bio.isNotEmpty) 'bio': bio,
        if (age != null) 'age': age,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (location != null && location.isNotEmpty) 'location': location,
        if (phoneNumber != null && phoneNumber.isNotEmpty)
          'phoneNumber': phoneNumber,
        if (education != null && education.isNotEmpty) 'education': education,
        if (pastExperience != null && pastExperience.isNotEmpty)
          'pastExperience': pastExperience,
        if (portfolioLink != null && portfolioLink.isNotEmpty)
          'portfolioLink': portfolioLink,
        'profilePic': "",
        'resume': "",
      };

      // Ensure offeringSkills is always a proper list (even if empty)
      if (offeringSkills != null && offeringSkills.isNotEmpty) {
        requestData['offeringSkills'] = List<String>.from(offeringSkills);
      } else {
        requestData['offeringSkills'] = <String>[];
      }

      // Ensure learningSkills is always a proper list (even if empty)
      if (learningSkills != null && learningSkills.isNotEmpty) {
        requestData['learningSkills'] = List<String>.from(learningSkills);
      } else {
        requestData['learningSkills'] = <String>[];
      }

      print(
        'Request data with offeringSkills: ${requestData['offeringSkills']}',
      );
      print(
        'Request data with learningSkills: ${requestData['learningSkills']}',
      );

      final response = await _apiService.post(
        '/users/signup',
        data: requestData,
      );

      if (response.statusCode == 201) {
        return {'success': true, 'user': response.data['user']};
      } else {
        return {'success': false, 'message': 'Signup failed'};
      }
    } on DioException catch (e) {
      // Handle different types of Dio errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return {
          'success': false,
          'message':
              'Connection timeout. Please check your internet connection.',
        };
      } else if (e.type == DioExceptionType.connectionError) {
        return {
          'success': false,
          'message':
              'Cannot connect to server. Please check your internet connection and try again.',
        };
      } else if (e.response?.statusCode == 409) {
        return {
          'success': false,
          'message': 'Email or phone number already exists',
        };
      } else if (e.response?.statusCode == 400) {
        final errorData =
            e.response?.data?['message'] ?? e.response?.data?['error'];
        String errorMessage = 'Invalid input data';
        if (errorData != null) {
          if (errorData is List) {
            errorMessage = errorData.join(', ');
          } else if (errorData is String) {
            errorMessage = errorData;
          } else {
            errorMessage = errorData.toString();
          }
        }
        return {'success': false, 'message': errorMessage};
      } else if (e.response != null) {
        // Server responded with error
        final errorData =
            e.response?.data?['message'] ?? e.response?.data?['error'];
        String errorMessage = 'Server error: ${e.response?.statusCode}';
        if (errorData != null) {
          if (errorData is List) {
            errorMessage = errorData.join(', ');
          } else if (errorData is String) {
            errorMessage = errorData;
          } else {
            errorMessage = errorData.toString();
          }
        }
        return {'success': false, 'message': errorMessage};
      } else {
        // No response from server
        return {
          'success': false,
          'message':
              e.message ?? 'Network error. Please check your connection.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/users/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];

        // Store tokens
        await _storage.write(key: _accessTokenKey, value: accessToken);
        await _storage.write(key: _refreshTokenKey, value: refreshToken);

        // Store user data
        await _storage.write(key: _userDataKey, value: userData.toString());

        // Set token in API service
        _apiService.setAuthToken(accessToken);

        return {
          'success': true,
          'user': userData,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        return {'success': false, 'message': 'Login failed'};
      }
    } on DioException catch (e) {
      // Handle different types of Dio errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return {
          'success': false,
          'message':
              'Connection timeout. Please check your internet connection.',
        };
      } else if (e.type == DioExceptionType.connectionError) {
        return {
          'success': false,
          'message':
              'Cannot connect to server. Please check your internet connection and try again.',
        };
      } else if (e.response?.statusCode == 401) {
        return {'success': false, 'message': 'Invalid email or password'};
      } else if (e.response?.statusCode == 400) {
        final errorData =
            e.response?.data?['message'] ?? e.response?.data?['error'];
        String errorMessage = 'Invalid input data';
        if (errorData != null) {
          if (errorData is List) {
            errorMessage = errorData.join(', ');
          } else if (errorData is String) {
            errorMessage = errorData;
          } else {
            errorMessage = errorData.toString();
          }
        }
        return {'success': false, 'message': errorMessage};
      } else if (e.response != null) {
        // Server responded with error
        final errorData =
            e.response?.data?['message'] ?? e.response?.data?['error'];
        String errorMessage = 'Server error: ${e.response?.statusCode}';
        if (errorData != null) {
          if (errorData is List) {
            errorMessage = errorData.join(', ');
          } else if (errorData is String) {
            errorMessage = errorData;
          } else {
            errorMessage = errorData.toString();
          }
        }
        return {'success': false, 'message': errorMessage};
      } else {
        // No response from server
        return {
          'success': false,
          'message':
              e.message ?? 'Network error. Please check your connection.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userDataKey);
    _apiService.setAuthToken(null);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get stored access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Initialize auth (check for stored token on app start)
  Future<void> initializeAuth() async {
    final token = await getAccessToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
  }

  // Get current user data from storage
  Future<Map<String, dynamic>?> getStoredUserData() async {
    // Note: This is a simplified version. In production, you'd want to
    // properly serialize/deserialize the user data
    // For now, user data should be fetched from the API after login
    return null;
  }
}
