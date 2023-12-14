import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';
import 'package:sizzle_starter/src/feature/auth/bloc/auth_bloc.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// Auth controller that handles authentication.
abstract interface class AuthController {
  /// Signs in the user with the given [email] and [password].
  void signInWithEmailAndPassword(String email, String password);

  /// Signs up the user with the given [email] and [password].
  void signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Signs out the current user.
  void signOut();

  /// Current authentication status.
  bool get authenticated;
}

/// Authentication scope that provides
/// abilities to sign in, sign up and sign out.
class AuthScope extends StatefulWidget {
  /// Create an [AuthScope] widget.
  const AuthScope({
    required this.child,
    super.key,
  });

  /// Child widget of this scope.
  final Widget child;

  /// Obtain the nearest [AuthController] up its widget tree.
  static AuthController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_AuthInherited>(listen: listen).authController;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> implements AuthController {
  late final AuthBloc _authBloc;
  late AuthState _authState;

  @override
  void initState() {
    _authBloc = DependenciesScope.of(context).authBloc;
    _authState = _authBloc.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          _authState = state;
          return _AuthInherited(
            authController: this,
            authState: state,
            child: widget.child,
          );
        },
      );

  @override
  void signInWithEmailAndPassword(String email, String password) {
    _authBloc.add(
      AuthEvent.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  void signOut() {
    _authBloc.add(const AuthEvent.signOut());
  }

  @override
  void signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) {
    _authBloc.add(
      AuthEvent.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      ),
    );
  }

  @override
  bool get authenticated =>
      _authState.status == AuthenticationStatus.authenticated;
}

/// Inherited widget that passes the [AuthController] down the widget tree.
class _AuthInherited extends InheritedWidget {
  /// Create _AuthInherited widget
  const _AuthInherited({
    required super.child,
    required this.authController,
    required AuthState authState,
  }) : _authState = authState;

  /// Auth controller
  final AuthController authController;

  final AuthState _authState;

  @override
  bool updateShouldNotify(_AuthInherited oldWidget) =>
      _authState != oldWidget._authState;
}
