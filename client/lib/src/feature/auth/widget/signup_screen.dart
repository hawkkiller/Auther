import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/feature/auth/widget/auth_scope.dart';

/// {@template signup_screen}
/// SignupScreen widget
/// {@endtemplate}
class SignupScreen extends StatefulWidget {
  /// {@macro signup_screen}
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sign up to Auther'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: Listenable.merge([
                _emailController,
                _passwordController,
                _usernameController,
              ]),
              builder: (context, _) => ElevatedButton(
                onPressed: () {
                  final auth = AuthScope.of(context);
                  auth.signUpWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                  );
                },
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => GoRouter.of(context).go('/signin'),
                child: const Text('Already have an account? Sign in.'),
              ),
            ),
          ],
        ),
      );
}
