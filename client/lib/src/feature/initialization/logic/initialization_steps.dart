import 'dart:async';

import 'package:auther_client/src/feature/authentication/data/auth_data_provider.dart';
import 'package:auther_client/src/feature/authentication/data/auth_repository.dart';
import 'package:auther_client/src/feature/initialization/model/initialization_progress.dart';
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
    'Auth Repository': (progress) {
      final authRepository = AuthRepositoryImpl(
        authDataProvider: AuthDataProviderImpl(
          baseUrl: progress.environmentStore.baseUrl,
          sharedPreferences: progress.dependencies.sharedPreferences,
        ),
      );
      progress.dependencies.authRepository = authRepository;
    },
  };
}
