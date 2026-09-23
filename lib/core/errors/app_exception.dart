class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});
}

class VpnException extends AppException {
  const VpnException(super.message, {super.code, super.details});
}
