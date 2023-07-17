import 'dart:async';

import 'package:auther_client/src/feature/authentication/data/auth_data_provider.dart';
import 'package:auther_client/src/feature/authentication/data/auth_repository.dart';
import 'package:auther_client/src/feature/authentication/logic/oauth_interceptor.dart';
import 'package:auther_client/src/feature/initialization/model/initialization_progress.dart';
import 'package:auther_client/src/feature/profile/data/profile_data_source.dart';
import 'package:auther_client/src/feature/profile/data/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The [InitializationProgress] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'Auth Repository & Rest Client': (progress) {
      final authDataProvider = AuthDataProviderImpl(
        baseUrl: progress.environmentStore.baseUrl,
        sharedPreferences: progress.dependencies.sharedPreferences,
      );
      final restClient = RestClient(
        Dio()..interceptors.add(OAuthInterceptor(authDataProvider)),
      );
      progress.dependencies.restClient = restClient;
      final authRepository = AuthRepositoryImpl(
        authDataProvider: authDataProvider,
      );
      progress.dependencies.authRepository = authRepository;
    },
    'Profile Repository': (progress) {
      final dataSource = ProfileDataSourceImpl(
        sharedPreferences: progress.dependencies.sharedPreferences,
        restClient: progress.dependencies.restClient,
      );
      final profileRepository = ProfileRepositoryImpl(
        dataSource: dataSource,
      );
      progress.dependencies.profileRepository = profileRepository;
    },
  };
}
