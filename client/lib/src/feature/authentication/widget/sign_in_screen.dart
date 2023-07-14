import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:auther_client/src/core/widget/logo.dart';
import 'package:auther_client/src/feature/authentication/widget/authentication_scope.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthenticationScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: LogoPainter(),
        ),
        leadingWidth: 100,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 700),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: ListView(
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      Localization.of(context).sign_in_to_auther,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: TextField(
                      controller: _emailController,
                      cursorHeight:
                          Theme.of(context).textTheme.bodyLarge!.fontSize,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: Localization.of(context).email,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextField(
                      controller: _passwordController,
                      cursorHeight:
                          Theme.of(context).textTheme.bodyLarge!.fontSize,
                      decoration: InputDecoration(
                        labelText: Localization.of(context).password,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ),
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        auth.error!,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: auth.isProcessing
                          ? null
                          : () {
                              auth.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                      child: auth.isProcessing
                          ? const CircularProgressIndicator.adaptive()
                          : Text(
                              Localization.of(context).sign_in,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text.rich(
                      TextSpan(
                        text: Localization.of(context).dont_have_account,
                        children: [
                          TextSpan(
                            // TODO(mlazebny): implement redirect to sign up screen
                            recognizer: TapGestureRecognizer()..onTap = () {},
                            text: ' ${Localization.of(context).sign_up}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
