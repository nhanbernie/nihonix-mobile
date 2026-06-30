class NoInternetException implements Exception {}

class UnauthorizedException implements Exception {}

class ValidationException implements Exception {
  final String? message;
  ValidationException([this.message]);
}

class ServerException implements Exception {}
