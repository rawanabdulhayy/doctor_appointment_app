class ConnectionException implements Exception {
  final String message;
  ConnectionException({required this.message});
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}