import 'package:auther_client/src/feature/authentication/widget/authentication_scope.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthenticationScope.of(context).signOut();
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Home'),
        ),
      );
}
