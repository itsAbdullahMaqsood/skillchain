import 'package:dio/dio.dart';

/// Callbacks for silent refresh flow. Set via [AuthInterceptor.configure].
class AuthInterceptorCallbacks {
  AuthInterceptorCallbacks({
    required this.getAccessToken,
    required this.refreshToken,
    required this.onLogoutRequired,
  });

  final Future<String?> Function() getAccessToken;
  final Future<String> Function() refreshToken;
  final void Function() onLogoutRequired;
}

/// Interceptor that: attaches access token to requests; on 401 refreshes token,
/// retries request once; on refresh failure clears auth and invokes logout callback.
/// Thread-safe: only one refresh at a time, queued requests wait and retry.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.dio, AuthInterceptorCallbacks? callbacks}) {
    if (callbacks != null) _callbacks = callbacks;
  }

  final Dio dio;

  static AuthInterceptorCallbacks? _callbacks;

  static void configure(AuthInterceptorCallbacks callbacks) {
    _callbacks = callbacks;
  }

  /// In-flight refresh future so concurrent 401s share one refresh.
  Future<String>? _refreshFuture;

  static const _retryKey = '_auth_retried';
  static const _refreshPath = '/users/refresh';
  static const _loginPath = '/users/login';
  static const _signupPath = '/users/signup';
  static const _verifyEmailPath = '/users/verify-email';
  static const _verifyOtpPathSignup = '/users/verify-otp-signup';
  static const _forgotPasswordPath = '/users/forgot-password';
  static const _verifyOtpPath = '/users/verify-otp';
  static const _resetPasswordPath = '/users/reset-password';

  bool _isAuthEndpoint(RequestOptions options) {
    final path = options.path;
    return path.contains(_refreshPath) ||
        path.contains(_loginPath) ||
        path.contains(_signupPath) ||
        path.contains(_verifyEmailPath) ||
        path.contains(_verifyOtpPathSignup) ||
        path.contains(_forgotPasswordPath) ||
        path.contains(_verifyOtpPath) ||
        path.contains(_resetPasswordPath);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_callbacks == null) {
      handler.next(options);
      return;
    }
    if (_isAuthEndpoint(options)) {
      handler.next(options);
      return;
    }
    try {
      final token = await _callbacks!.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Proceed without token; may get 401
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final options = err.requestOptions;

    if (response?.statusCode != 401 ||
        _callbacks == null ||
        _isAuthEndpoint(options)) {
      handler.next(err);
      return;
    }

    if (options.extra[_retryKey] == true) {
      handler.next(err);
      return;
    }

    try {
      _refreshFuture ??= _callbacks!.refreshToken();
      await _refreshFuture!;
    } catch (_) {
      _refreshFuture = null;
      _callbacks!.onLogoutRequired();
      handler.next(err);
      return;
    } finally {
      _refreshFuture = null;
    }

    options.extra[_retryKey] = true;
    try {
      final token = await _callbacks!.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final res = await dio.fetch(options);
      handler.resolve(res);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }
}
