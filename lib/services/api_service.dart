import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:skillchain/core/network/auth_interceptor.dart';

class ApiService {
  // PRODUCTION API URL
  static const String baseUrl = 'https://skill-chain-backend.lgufyp.app';

  static Dio? _sharedDio;
  static Dio get _dio {
    _sharedDio ??= _createDio();
    return _sharedDio!;
  }

  ApiService() {
    // Use shared Dio so all instances share the same interceptor and auth state
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(dio: dio));

    // Handle SSL certificate issues for development
    // WARNING: Only use this in development. Remove in production!
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
            return true;
          };
      return client;
    };
    return dio;
  }

  /// Call once at app startup (e.g. from main) to enable 401 → refresh → retry and logout redirect.
  static void configureAuth(AuthInterceptorCallbacks callbacks) {
    AuthInterceptor.configure(callbacks);
  }

  Dio get dio => _dio;

  // Helper method for GET requests
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method for POST requests
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method for PUT requests
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method for DELETE requests
  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// POST with multipart/form-data (e.g. file uploads). [data] is FormData.
  Future<Response> postMultipart(
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT with multipart/form-data (e.g. file uploads). [data] is FormData.
  Future<Response> putMultipart(
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Set authorization token on the shared Dio (used after login/refresh).
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}
