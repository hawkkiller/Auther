import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';
import 'package:sizzle_starter/src/feature/auth/widget/auth_scope.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Localization.of(context).app_title),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: AuthScope.of(context).signOut,
            ),
          ],
        ),
      );
}
