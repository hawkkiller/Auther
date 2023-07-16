import 'package:shared/model.dart';

abstract interface class AuthException implements Exception {
  const AuthException({
    this.message,
  });

  final Object? message;

  ErrorCode get errorCode;
}

final class AuthException$UserExists implements AuthException {
  const AuthException$UserExists() : message = 'User already exists';

  @override
  final Object? message;

  @override
  ErrorCode get errorCode => ErrorCode.userExists;

  @override
  String toString() => 'AuthException\$UserExists: $message';
}

final class AuthException$UserNotFound implements AuthException {
  const AuthException$UserNotFound() : message = 'User not found';

  @override
  final Object? message;

  @override
  ErrorCode get errorCode => ErrorCode.userNotFound;

  @override
  String toString() => 'AuthException\$UserNotFound: $message';
}

final class AuthException$UnknownDatabaseError implements AuthException {
  const AuthException$UnknownDatabaseError([
    this.message = 'Unknown database error',
  ]);

  @override
  final Object? message;

  @override
  ErrorCode get errorCode => ErrorCode.unknown;

  @override
  String toString() => 'AuthException\$UnknownDatabaseError: $message';
}

final class AuthException$TokenMalformed implements AuthException {
  const AuthException$TokenMalformed() : message = 'Token malformed';

  @override
  final Object? message;

  @override
  ErrorCode get errorCode => ErrorCode.tokenMalformed;

  @override
  String toString() => 'AuthException\$TokenMalformed: $message';
}

final class AuthException$TokenExpired implements AuthException {
  const AuthException$TokenExpired() : message = 'Token expired';

  @override
  final Object? message;

  @override
  ErrorCode get errorCode => ErrorCode.tokenExpired;

  @override
  String toString() => 'AuthException\$TokenExpired: $message';
}
