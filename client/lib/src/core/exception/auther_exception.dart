import 'package:auther_client/src/core/utils/annotation.dart';
import 'package:meta/meta.dart';
import 'package:shared/model.dart';

@immutable
@exception
sealed class AutherException implements Exception {
  const AutherException({
    required this.message,
    required this.code,
  });

  final String message;

  final ErrorCode code;

  @override
  String toString() => 'AutherException: $message, code: $code';
}

final class AutherException$Unknown extends AutherException {
  const AutherException$Unknown({super.message = 'Unknown'})
      : super(code: ErrorCode.unknown);
}

sealed class AuthException extends AutherException {
  const AuthException({required super.message, required super.code});
}

final class AuthException$UserNotFound extends AuthException {
  const AuthException$UserNotFound()
      : super(message: 'User not found', code: ErrorCode.userNotFound);
}

final class AuthException$UserExists extends AuthException {
  const AuthException$UserExists()
      : super(message: 'User exists', code: ErrorCode.userExists);
}

final class AuthException$InvalidBody extends AuthException {
  const AuthException$InvalidBody()
      : super(message: 'Invalid body', code: ErrorCode.invalidBody);
}

final class AuthException$TokenMalformed extends AuthException {
  const AuthException$TokenMalformed()
      : super(message: 'Token malformed', code: ErrorCode.tokenMalformed);
}

final class AuthException$RefreshTokenExpired extends AuthException {
  const AuthException$RefreshTokenExpired()
      : super(
          message: 'Refresh token expired',
          code: ErrorCode.refreshTokenExpired,
        );
}
