import 'package:auther_client/src/core/utils/error_util.dart';
import 'package:auther_client/src/core/utils/mixin/set_state_mixin.dart';
import 'package:auther_client/src/feature/authentication/data/auth_repository.dart';
import 'package:auther_client/src/feature/authentication/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// {@template auth_state}
/// AuthState.
/// {@endtemplate}
sealed class AuthState extends _$AuthStateBase {
  /// {@macro auth_state}
  const AuthState({required super.user, required super.message});

  /// Idling state
  /// {@macro auth_state}
  const factory AuthState.idle({
    User? user,
    String message,
    String? error,
  }) = AuthState$Idle;

  /// Processing
  /// {@macro auth_state}
  const factory AuthState.processing({
    required User? user,
    String message,
  }) = AuthState$Processing;
}

/// Idling state
/// {@nodoc}
final class AuthState$Idle extends AuthState with _$AuthState {
  /// {@nodoc}
  const AuthState$Idle({
    super.user,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// Processing
/// {@nodoc}
final class AuthState$Processing extends AuthState with _$AuthState {
  /// {@nodoc}
  const AuthState$Processing({
    required super.user,
    super.message = 'Processing',
  });

  @override
  String? get error => null;
}

/// {@nodoc}
base mixin _$AuthState on AuthState {}

/// Pattern matching for [AuthState].
typedef AuthStateMatch<R, S extends AuthState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$AuthStateBase {
  /// {@nodoc}
  const _$AuthStateBase({required this.user, required this.message});

  /// Data entity payload.
  @nonVirtual
  final User? user;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Error message.
  abstract final String? error;

  /// If an error has occurred?
  bool get hasError => error != null;

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [AuthState].
  R map<R>({
    required AuthStateMatch<R, AuthState$Idle> idle,
    required AuthStateMatch<R, AuthState$Processing> processing,
  }) =>
      switch (this) {
        final AuthState$Idle s => idle(s),
        final AuthState$Processing s => processing(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [AuthState].
  R maybeMap<R>({
    required R Function() orElse,
    AuthStateMatch<R, AuthState$Idle>? idle,
    AuthStateMatch<R, AuthState$Processing>? processing,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
      );

  /// Pattern matching for [AuthState].
  R? mapOrNull<R>({
    AuthStateMatch<R, AuthState$Idle>? idle,
    AuthStateMatch<R, AuthState$Processing>? processing,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
      );

  @override
  int get hashCode => user.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('AuthState(')
      ..write('user: $user, ');
    if (error != null) buffer.write('error: $error, ');
    buffer
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}

@immutable
sealed class AuthEvent extends _$AuthEventBase {
  const AuthEvent();

  const factory AuthEvent.signInWithEmailAndPassword({
    required String email,
    required String password,
  }) = _AuthEventSignInWithEmailAndPassword;

  const factory AuthEvent.signInAnonymously() = _AuthEventSignInAnonymously;

  const factory AuthEvent.signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) = _AuthEventSignUpWithEmailAndPassword;

  const factory AuthEvent.signOut() = _AuthEventSignOut;
}

final class _AuthEventSignUpWithEmailAndPassword extends AuthEvent {
  const _AuthEventSignUpWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.username,
  }) : super();

  final String email;
  final String password;
  final String username;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('AuthEvent.signUp(')
      ..write('email: $email, ')
      ..write('password: $password, ')
      ..write('username: $username')
      ..write(')');
    return buffer.toString();
  }
}

final class _AuthEventSignInWithEmailAndPassword extends AuthEvent {
  const _AuthEventSignInWithEmailAndPassword({
    required this.email,
    required this.password,
  }) : super();

  final String email;
  final String password;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('AuthEvent.signIn(')
      ..write('email: $email, ')
      ..write('password: $password')
      ..write(')');
    return buffer.toString();
  }
}

final class _AuthEventSignInAnonymously extends AuthEvent {
  const _AuthEventSignInAnonymously() : super();

  @override
  String toString() => 'AuthEvent.signInAnonymously()';
}

final class _AuthEventSignOut extends AuthEvent {
  const _AuthEventSignOut() : super();

  @override
  String toString() => 'AuthEvent.signOut()';
}

typedef AuthEventMatch<R, S extends AuthEvent> = R Function(S event);

abstract base class _$AuthEventBase {
  const _$AuthEventBase();

  R map<R>({
    required AuthEventMatch<R, _AuthEventSignInWithEmailAndPassword>
        signInWithEmailAndPassword,
    required AuthEventMatch<R, _AuthEventSignInAnonymously> signInAnonymously,
    required AuthEventMatch<R, _AuthEventSignOut> signOut,
    required AuthEventMatch<R, _AuthEventSignUpWithEmailAndPassword>
        signUpWithEmailAndPassword,
  }) =>
      switch (this) {
        final _AuthEventSignInWithEmailAndPassword s =>
          signInWithEmailAndPassword(s),
        final _AuthEventSignInAnonymously s => signInAnonymously(s),
        final _AuthEventSignOut s => signOut(s),
        final _AuthEventSignUpWithEmailAndPassword s =>
          signUpWithEmailAndPassword(s),
        _ => throw AssertionError(),
      };

  R maybeMap<R>({
    required R Function() orElse,
    AuthEventMatch<R, _AuthEventSignInWithEmailAndPassword>?
        signInWithEmailAndPassword,
    AuthEventMatch<R, _AuthEventSignInAnonymously>? signInAnonymously,
    AuthEventMatch<R, _AuthEventSignOut>? signOut,
    AuthEventMatch<R, _AuthEventSignUpWithEmailAndPassword>?
        signUpWithEmailAndPassword,
  }) =>
      map<R>(
        signInWithEmailAndPassword:
            signInWithEmailAndPassword ?? (_) => orElse(),
        signInAnonymously: signInAnonymously ?? (_) => orElse(),
        signOut: signOut ?? (_) => orElse(),
        signUpWithEmailAndPassword:
            signUpWithEmailAndPassword ?? (_) => orElse(),
      );

  R? mapOrNull<R>({
    AuthEventMatch<R, _AuthEventSignInWithEmailAndPassword>?
        signInWithEmailAndPassword,
    AuthEventMatch<R, _AuthEventSignInAnonymously>? signInAnonymously,
    AuthEventMatch<R, _AuthEventSignOut>? signOut,
    AuthEventMatch<R, _AuthEventSignUpWithEmailAndPassword>?
        signUpWithEmailAndPassword,
  }) =>
      map<R?>(
        signInWithEmailAndPassword: signInWithEmailAndPassword ?? (_) => null,
        signInAnonymously: signInAnonymously ?? (_) => null,
        signOut: signOut ?? (_) => null,
        signUpWithEmailAndPassword:
            signUpWithEmailAndPassword ?? (_) => null,
      );
}

class AuthBloc extends Bloc<AuthEvent, AuthState> with SetStateMixin {
  AuthBloc(this._authRepository) : super(const AuthState$Idle()) {
    _authRepository.userStream
        .map((user) => AuthState$Idle(user: user))
        .where((event) => !identical(event, state))
        .listen(setState);

    on<AuthEvent>(
      (event, emit) => event.map(
        signInWithEmailAndPassword: (e) => _signInWithEmailAndPassword(e, emit),
        signInAnonymously: (e) => _signInAnonymously(e, emit),
        signOut: (e) => _signOut(e, emit),
        signUpWithEmailAndPassword: (e) => _signUpWithEmailAndPassword(e, emit),
      ),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _signUpWithEmailAndPassword(
    _AuthEventSignUpWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(user: state.user));
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(AuthState.idle(user: user));
    } on Object catch (e) {
      emit(
        AuthState.idle(error: ErrorUtil.formatError(e)),
      );
      rethrow;
    }
  }

  Future<void> _signInWithEmailAndPassword(
    _AuthEventSignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(user: state.user));
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.idle(user: user));
    } on Object catch (e) {
      emit(
        AuthState.idle(error: ErrorUtil.formatError(e)),
      );
      rethrow;
    }
  }

  Future<void> _signInAnonymously(
    _AuthEventSignInAnonymously event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(user: state.user));
    try {
      final user = await _authRepository.signInAnonymously();
      emit(
        AuthState.idle(user: user),
      );
    } on Object catch (e) {
      emit(
        AuthState.idle(error: ErrorUtil.formatError(e)),
      );
      rethrow;
    }
  }

  Future<void> _signOut(
    _AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(user: state.user));
    try {
      emit(
        const AuthState.idle(),
      );
    } on Object catch (e) {
      emit(
        AuthState.idle(error: ErrorUtil.formatError(e)),
      );
      rethrow;
    }
  }
}
