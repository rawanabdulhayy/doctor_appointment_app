class ConnectionException implements Exception {
  final String message;
  ConnectionException({required this.message});
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}

class UnauthorizedException implements Exception {}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException({required this.errors});
}

class NetworkException implements Exception {
  final NetworkExceptionType type;
  NetworkException({required this.type});
}

enum NetworkExceptionType {
  timeout,
  noConnection,
  serverError,
}