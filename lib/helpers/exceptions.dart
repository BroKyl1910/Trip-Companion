import 'package:flutter/services.dart';

class ExceptionAdapter {
  AuthenticationException firebaseToAuthenticationException(dynamic e) {
    AuthenticationExceptionType type = AuthenticationExceptionType.UNKNOWN;
    String message = "Something went wrong";
    PlatformException ex = e as PlatformException;
    print("Platform Exception ${ex.code}");
    switch (ex.code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_WRONG_PASSWORD":
      case "ERROR_USER_NOT_FOUND":
        message = "Incorrect username or password";
        type = AuthenticationExceptionType.INCORRECT_CREDENTIALS;
        break;
      case "ERROR_NETWORK_REQUEST_FAILED":
        message = "Network error has occured";
        type = AuthenticationExceptionType.NETWORK_ERROR;
        break;
      case "ERROR_USER_DISABLED":
        message = "Account has been disabled";
        type = AuthenticationExceptionType.ACCOUNT_DISABLED;
        break;
      case "ERROR_INVALID_CREDENTIAL":
        message = "Credentials are malformed or expired";
        type = AuthenticationExceptionType.INVALID_CREDENTIALS;
        break;
      case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
      case "ERROR_EMAIL_ALREADY_IN_USE":
        message = "There is already an account with this email";
        type = AuthenticationExceptionType.ALREADY_REGISTERED;
        break;
      case "error":
      //As far as I can see, general error means empty string
        message = "Please fill in all fields";
        type = AuthenticationExceptionType.NULL_VALUE;
        break;
      default:
        message = "Oops, something went wrong";
        type = AuthenticationExceptionType.UNKNOWN;
    }
    return AuthenticationException(message: message, type: type);
  }
}

class AuthenticationException implements Exception {
  final String message;
  final AuthenticationExceptionType type;

  AuthenticationException({this.message, this.type});
}

enum AuthenticationExceptionType {
  ACCOUNT_DISABLED,
  INCORRECT_CREDENTIALS,
  NETWORK_ERROR,
  NULL_VALUE,
  INVALID_CREDENTIALS,
  ALREADY_REGISTERED,
  UNKNOWN
}