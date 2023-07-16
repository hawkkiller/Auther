import 'package:auther_client/src/core/exception/auther_exception.dart';
import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:shared/model.dart';

sealed class ErrorUtil {
  static String formatError(Object error) => switch (error) {
        final AutherException e => _localizeAutherException(e),
        final Exception e => _localizeError(
            'Exception occured: $e',
            (l) => l.exception_occured(e.toString()),
          ),
        final dynamic e => _localizeError(
            'Unknown Exception: $e',
            (l) => l.unknown_error(e.toString()),
          ),
      };

  static String _localizeAutherException(
    AutherException exception,
  ) =>
      switch (exception) {
        final AuthException$UserExists _ => _localizeError(
            'User exists',
            (l) => l.user_exists,
          ),
        final AuthException$UserNotFound _ => _localizeError(
            'User not found',
            (l) => l.user_not_found,
          ),
        _ => _localizeError(
            'Unknown',
            (l) => l.unknown_error(exception.toString()),
          ),
      };

  static String _localizeError(
    String fallback,
    String Function(Localization l) localize,
  ) {
    try {
      return localize(Localization.current);
    } on Object {
      return fallback;
    }
  }

  static Never throwAutherException(ErrorCode code, String message) =>
      throw switch (code) {
        ErrorCode.userExists => const AuthException$UserExists(),
        ErrorCode.userNotFound => const AuthException$UserNotFound(),
        ErrorCode.invalidBody => const AuthException$InvalidBody(),
        ErrorCode.tokenMalformed => const AuthException$TokenMalformed(),
        ErrorCode.tokenExpired =>
          const AuthException$RefreshTokenExpired(),
        ErrorCode.unknown => AutherException$Unknown(message: message),
      };
}
