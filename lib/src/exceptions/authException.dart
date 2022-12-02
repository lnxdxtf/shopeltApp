class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_NOT_FOUND": "E-mail not found",
    "INVALID_PASSWORD": "Password is invalid",
    "USER_DISABLED": "User disabled",
    "EMAIL_EXISTS": "E-mail already exists",
    "OPERATION_NOT_ALLOWED": "Operation not allowed",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Too many attempts try later",
  };

  final String keyError;

  AuthException(this.keyError);

  @override
  String toString() {
    return errors[keyError] ?? "Authentication Error";
  }
}
