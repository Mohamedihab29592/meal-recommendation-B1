class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({
    required this.message,
    required this.statusCode
  });

  bool get is503Error => statusCode == 503;
  bool get is404Error => statusCode == 404;

  @override
  String toString() => 'ServerException: $message (Status $statusCode)';
}