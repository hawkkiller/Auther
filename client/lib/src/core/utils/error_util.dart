import 'package:auther_client/src/core/localization/app_localization.dart';

sealed class ErrorUtil {
  static String formatError(Object error) => switch (error) {
        final Exception e => _localizeError(
            'Exception occured: $e',
            (l) => l.exception_occured(e.toString()),
          ),
        final dynamic e => _localizeError(
            'Unknown Exception: $e',
            (l) => l.unknown_error(e.toString()),
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
}
