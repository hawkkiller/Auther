import 'package:auther_client/src/feature/initialization/model/enum/environment.dart';

abstract class IEnvironmentStore {
  abstract final Environment environment;
  abstract final String sentryDsn;
  abstract final String baseUrl;

  bool get isProduction => environment == Environment.prod;
}

class EnvironmentStore extends IEnvironmentStore {
  EnvironmentStore();

  static final _env = Environment.fromEnvironment(
    const String.fromEnvironment('ENV'),
  );

  @override
  Environment get environment => _env;

  @override
  String get baseUrl => const bool.hasEnvironment('BASE_URL')
      ? const String.fromEnvironment('BASE_URL')
      : (throw Exception('BASE_URL not set'));

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
