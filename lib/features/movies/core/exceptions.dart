class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final int statusCode;
  final String message;
  ServerException(this.statusCode, this.message);
}

class ParsingException implements Exception {
  final String message;
  ParsingException(this.message);
}