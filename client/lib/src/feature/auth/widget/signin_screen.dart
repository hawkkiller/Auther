import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/feature/auth/widget/auth_scope.dart';

/// {@template signin_screen}
/// SigninScreen widget
/// {@endtemplate}
class SignInScreen extends StatefulWidget {
  /// {@macro signin_screen}
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sign in to Auther'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
              ]),
              builder: (context, _) {
                final email = _emailController.text;
                final password = _passwordController.text;

                final enabled = email.isNotEmpty && password.isNotEmpty;

                return ElevatedButton(
                  onPressed: enabled
                      ? () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          AuthScope.of(context).signInWithEmailAndPassword(
                            email,
                            password,
                          );
                        }
                      : null,
                  child: const Text('Sign in'),
                );
              },
            ),
          ],
        ),
      );
}
