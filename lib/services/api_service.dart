import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

class ApiService {
  // PRODUCTION API URL
  // Replace this with your deployed backend URL after deploying to a cloud service
  // Examples:
  // - Railway: 'https://your-app.railway.app/api'
  // - Render: 'https://your-app.onrender.com/api'
  // - Heroku: 'https://your-app.herokuapp.com/api'
  // - Custom Domain: 'https://api.yourdomain.com/api'
  //
  // For local development/testing on same network:
  // Use your computer's local IP: 'https://192.168.1.100:3001/api'
  //
  // IMPORTANT: After deploying your backend, update this URL and rebuild the APK
  static const String baseUrl =
      'https://skill-chain-backend-production.up.railway.app';

  late Dio _dio;

  ApiService() {
    _dio = Dio(
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

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to headers if available
          // This will be handled by AuthService
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          handler.next(error);
        },
      ),
    );

    // Handle SSL certificate issues for development
    // WARNING: Only use this in development. Remove in production!
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
            // Accept all certificates for development
            return true;
          };
      return client;
    };
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
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
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
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Set authorization token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}
