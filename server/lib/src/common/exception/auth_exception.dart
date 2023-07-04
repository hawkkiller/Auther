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
