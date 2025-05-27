class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  NetworkException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'NetworkException: $message (StatusCode: $statusCode, OriginalError: $error)';
  }
}