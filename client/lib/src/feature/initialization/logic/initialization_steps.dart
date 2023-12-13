import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/rest_client_dio.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sizzle_starter/src/feature/auth/data/auth_datasource.dart';
import 'package:sizzle_starter/src/feature/auth/data/auth_repository.dart';
import 'package:sizzle_starter/src/feature/auth/data/refresh_client.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:sizzle_starter/src/feature/settings/data/locale_datasource.dart';
import 'package:sizzle_starter/src/feature/settings/data/settings_repository.dart';
import 'package:sizzle_starter/src/feature/settings/data/theme_datasource.dart';
import 'package:sizzle_starter/src/feature/settings/data/theme_mode_codec.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The [Dependencies] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'Settings Repository': (progress) {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final themeDataSource = ThemeDataSourceImpl(
        sharedPreferences: sharedPreferences,
        codec: const ThemeModeCodec(),
      );
      final localeDataSource = LocaleDataSourceImpl(sharedPreferences);
      progress.dependencies.settingsRepository = SettingsRepositoryImpl(
        themeDataSource: themeDataSource,
        localeDataSource: localeDataSource,
      );
    },
    'AuthRepository': (progress) async {
      final dio = Dio();

      final restClient = RestClientDio(
        baseUrl: 'https://auther.lazebny.io/',
        dio: dio,
      );

      final authDataSource = AuthDataSourceImpl(
        client: restClient,
        sharedPreferences: progress.dependencies.sharedPreferences,
      );

      final oauthInterceptor = OAuthInterceptor(
        storage: authDataSource,
        refreshClient: RefreshClientImpl(),
      );

      dio.interceptors.add(oauthInterceptor);

      final authRepository = AuthRepositoryImpl(
        authDataSource: authDataSource,
        authStatusDataSource: oauthInterceptor,
      );

      progress.dependencies.authRepository = authRepository;
    },
    'AuthBloc': (progress) async {
      final authRepository = progress.dependencies.authRepository;
      final authBloc = AuthBloc(authRepository);
      final resolvedState = await authBloc.stream
          .where((event) => event.status != AuthenticationStatus.initial)
          .first;
      logger.verbose('Resolved auth state: $resolvedState');
      progress.dependencies.authBloc = authBloc;
    },
  };
}
