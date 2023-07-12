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

  /// Sign out the current user
  void signOut();

  /// The current user
  User? get user;

  /// Whether the current user is being processed
  bool get isProcessing;

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

  User? _user;
  bool _processing = false;

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
    if (_user != state.user || _processing != state.isProcessing) {
      setState(() {
        _user = state.user;
        _processing = state.isProcessing;
      });
    }
  }

  @override
  User? get user => _user;

  @override
  bool get isProcessing => _processing;

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
  void signOut() => _authBloc.add(
        const AuthEvent.signOut(),
      );

  @override
  Widget build(BuildContext context) => _InheritedAuthentication(
        controller: this,
        child: widget.child,
      );
}

class _InheritedAuthentication extends InheritedWidget {
  const _InheritedAuthentication({
    required this.controller,
    required super.child,
  });

  final AuthenticationController controller;

  @override
  bool updateShouldNotify(_InheritedAuthentication oldWidget) =>
      controller.user != oldWidget.controller.user ||
      controller.isProcessing != oldWidget.controller.isProcessing;
}
