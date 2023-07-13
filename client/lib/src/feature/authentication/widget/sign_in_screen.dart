import 'package:auther_client/src/core/assets/generated/assets.gen.dart';
import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:auther_client/src/core/widget/logo.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Row(
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LogoPainter(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 86),
                      child: Text(
                        Localization.of(context).welcome_back,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextField(
                      cursorHeight:
                          Theme.of(context).textTheme.bodyLarge!.fontSize,
                      decoration: InputDecoration(
                        labelText: Localization.of(context).email,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextField(
                        cursorHeight:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        decoration: InputDecoration(
                          labelText: Localization.of(context).password,
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
                        onPressed: () {},
                        child: Text(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
            const SizedBox(width: 32),
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                child: Image.asset(
                  Assets.images.whale.path,
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      );
}
