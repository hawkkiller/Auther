import 'package:auther_client/src/feature/authentication/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependencies container
abstract interface class Dependencies {
  /// Shared preferences
  abstract final SharedPreferences sharedPreferences;

  /// Authentication repository
  abstract final AuthRepository authRepository;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze();
}

/// Mutable version of dependencies
///
/// Used to build dependencies
final class Dependencies$Mutable implements Dependencies {
  Dependencies$Mutable();

  @override
  late SharedPreferences sharedPreferences;

  @override
  late AuthRepository authRepository;

  @override
  Dependencies freeze() => _Dependencies$Immutable(
        sharedPreferences: sharedPreferences,
        authRepository: authRepository,
      );
}

/// Immutable version of dependencies
///
/// Used to store dependencies
final class _Dependencies$Immutable implements Dependencies {
  const _Dependencies$Immutable({
    required this.sharedPreferences,
    required this.authRepository,
  });

  @override
  final SharedPreferences sharedPreferences;

  @override
  final AuthRepository authRepository;

  @override
  Dependencies freeze() => this;
}

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.stepCount,
    required this.msSpent,
  });

  final Dependencies dependencies;
  final int stepCount;
  final int msSpent;
}
