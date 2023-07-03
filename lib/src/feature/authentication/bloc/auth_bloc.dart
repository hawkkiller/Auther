import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/feature/authentication/data/auth_repository.dart';

@immutable
sealed class AuthState {
  const AuthState();

  const factory AuthState.idle() = _AuthStateIdle;

  const factory AuthState.authenticated({
    required String? email,
    required bool isAnonymous,
  }) = _AuthStateAuthenticated;

  const factory AuthState.unauthenticated() = _AuthStateUnauthenticated;
}

final class _AuthStateIdle extends AuthState {
  const _AuthStateIdle();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AuthStateIdle && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

final class _AuthStateAuthenticated extends AuthState {
  const _AuthStateAuthenticated({
    required this.email,
    required this.isAnonymous,
  });

  final String? email;
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AuthStateAuthenticated &&
          runtimeType == other.runtimeType &&
          isAnonymous == other.isAnonymous;

  @override
  int get hashCode => isAnonymous.hashCode;
}

final class _AuthStateUnauthenticated extends AuthState {
  const _AuthStateUnauthenticated();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AuthStateUnauthenticated && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this._authRepository) : super(const _AuthStateIdle()) {
    _authRepository.userStream.listen((user) {
      if (user == null) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(
          AuthState.authenticated(
            email: user.email,
            isAnonymous: user.isAnonymous,
          ),
        );
      }
    });
  }

  final AuthRepository _authRepository;
}
