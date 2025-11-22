class ConnectionException implements Exception {
  final String message;
  ConnectionException({required this.message});
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}