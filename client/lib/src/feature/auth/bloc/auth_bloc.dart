import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/utils/mixins/set_state_mixin.dart';
import 'package:sizzle_starter/src/feature/auth/data/auth_repository.dart';

part 'auth_bloc.freezed.dart';

/// Events that can be dispatched to the [AuthBloc].
@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Signs in the user with the given [email] and [password].
  const factory AuthEvent.signInWithEmailAndPassword({
    required String email,
    required String password,
  }) = _SignInAuthEvent;

  /// Signs up the user with the given [email] and [password].
  const factory AuthEvent.signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) = _SignUpAuthEvent;

  /// Signs out the current user.
  const factory AuthEvent.signOut() = _SignOutAuthEvent;
}

/// States that can be emitted by the [AuthBloc].
@freezed
sealed class AuthState with _$AuthState {
  /// Idle state.
  const factory AuthState.idle({
    required AuthenticationStatus status,
    Object? error,
  }) = _IdleAuthState;

  /// Processing state.
  const factory AuthState.processing({
    required AuthenticationStatus status,
  }) = _ProcessingAuthState;
}

/// Authentication bloc that handles authentication.
class AuthBloc extends Bloc<AuthEvent, AuthState> with SetStateMixin {
  /// Create an [AuthBloc] instance.
  AuthBloc(this._repository)
      : super(
          const AuthState.idle(status: AuthenticationStatus.initial),
        ) {
    _authStateSubscription = _repository
        .getAuthStateChanges()
        .map((status) => AuthState.idle(status: status))
        .where((newState) => newState != state)
        .listen(setState);

    on<AuthEvent>(
      (event, emit) => event.map(
        signInWithEmailAndPassword: (e) => _signInWithEmailAndPassword(e, emit),
        signUpWithEmailAndPassword: (e) => _signUpWithEmailAndPassword(e, emit),
        signOut: (e) => _signOut(e, emit),
      ),
    );
  }

  final AuthRepository _repository;

  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    await super.close();
  }

  Future<void> _signInWithEmailAndPassword(
    _SignInAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(status: state.status));
    try {
      await _repository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(const AuthState.idle(status: AuthenticationStatus.authenticated));
    } on Object catch (e) {
      emit(
        AuthState.idle(status: state.status, error: e),
      );
      rethrow;
    }
  }

  Future<void> _signUpWithEmailAndPassword(
    _SignUpAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(status: state.status));
    try {
      await _repository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(const AuthState.idle(status: AuthenticationStatus.authenticated));
    } on Object catch (e) {
      emit(
        AuthState.idle(status: state.status, error: e),
      );
      rethrow;
    }
  }

  Future<void> _signOut(
    _SignOutAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(status: state.status));
    try {
      emit(const AuthState.idle(status: AuthenticationStatus.unauthenticated));
      await _repository.signOut();
      emit(const AuthState.idle(status: AuthenticationStatus.unauthenticated));
    } on Object catch (e) {
      emit(
        AuthState.idle(status: state.status, error: e),
      );
      rethrow;
    }
  }
}
