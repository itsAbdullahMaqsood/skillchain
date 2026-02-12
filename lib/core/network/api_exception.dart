/// Centralized API error for signup and auth flows.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  final String message;
  final int? statusCode;
  final String? error;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
