import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/feature/auth/widget/signin_screen.dart';
import 'package:sizzle_starter/src/feature/auth/widget/signup_screen.dart';
import 'package:sizzle_starter/src/feature/home/widget/home_screen.dart';

part 'routes.g.dart';

/// Home route that user will see when they are logged in.
@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// Login route that user will see when they are not logged in.
@TypedGoRoute<SignInRoute>(path: '/signin')
class SignInRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignInScreen();
}

/// Register route that user will see when they are not logged in.
@TypedGoRoute<SignUpRoute>(path: '/signup')
class SignUpRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignupScreen();
}
