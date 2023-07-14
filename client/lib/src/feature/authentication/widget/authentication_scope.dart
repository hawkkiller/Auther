import 'package:auther_client/src/core/utils/mixin/scope_mixin.dart';
import 'package:auther_client/src/feature/authentication/bloc/auth_bloc.dart';
import 'package:auther_client/src/feature/authentication/model/user.dart';
import 'package:auther_client/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';

abstract mixin class AuthenticationController {
  /// Sign in with [email] and [password]
  void signInWithEmailAndPassword(String email, String password);

  /// Sign in as a guest
  void signInAnonymously();

  /// Sign up with [email], [password] and [username]
  void signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  );

  /// Sign out the current user
  void signOut();

  /// The current user
  User? get user;

  /// Whether the current user is being processed
  bool get isProcessing;

  /// The error message
  String? get error;

  /// Whether the current user is authenticated
  bool get isAuthenticated => user != null;
}

class AuthenticationScope extends StatefulWidget {
  const AuthenticationScope({required this.child, super.key});

  final Widget child;

  static AuthenticationController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_InheritedAuthentication>(
        context,
        listen: listen,
      ).controller;

  @override
  State<AuthenticationScope> createState() => _AuthenticationScopeState();
}

class _AuthenticationScopeState extends State<AuthenticationScope>
    with AuthenticationController {
  late final AuthBloc _authBloc;

  AuthState? _state;

  @override
  void initState() {
    _authBloc = AuthBloc(
      DependenciesScope.dependenciesOf(context).authRepository,
    )..stream.listen(_onAuthStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onAuthStateChanged(AuthState state) {
    if (!identical(state, _state)) {
      setState(() {
        _state = state;
      });
    }
  }

  @override
  User? get user => _state?.user;

  @override
  String? get error => _state?.error;

  @override
  bool get isProcessing => _state?.isProcessing ?? false;

  @override
  void signInAnonymously() => _authBloc.add(
        const AuthEvent.signInAnonymously(),
      );

  @override
  void signInWithEmailAndPassword(String email, String password) =>
      _authBloc.add(
        AuthEvent.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      );

  @override
  void signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) =>
      _authBloc.add(
        AuthEvent.signUpWithEmailAndPassword(
          email: email,
          password: password,
          username: username,
        ),
      );

  @override
  void signOut() => _authBloc.add(
        const AuthEvent.signOut(),
      );

  @override
  Widget build(BuildContext context) => _InheritedAuthentication(
        controller: this,
        state: _state,
        child: widget.child,
      );
}

class _InheritedAuthentication extends InheritedWidget {
  const _InheritedAuthentication({
    required this.controller,
    required this.state,
    required super.child,
  });

  final AuthState? state;

  final AuthenticationController controller;

  @override
  bool updateShouldNotify(_InheritedAuthentication oldWidget) =>
      state != oldWidget.state;
}
