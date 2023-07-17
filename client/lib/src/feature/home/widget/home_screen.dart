import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:auther_client/src/feature/authentication/widget/authentication_scope.dart';
import 'package:auther_client/src/feature/profile/widget/profile_scope.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ProfileScope.of(context, listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileScope = ProfileScope.of(context);
    return Scaffold(
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
      body: ListView(
        children: [
          if (profileScope.profile == null)
            const Center(child: CircularProgressIndicator.adaptive())
          else
            Text(
              Localization.of(context).welcome_user(
                profileScope.profile!.username,
              ),
              style: Theme.of(context).textTheme.displaySmall,
            ),
        ],
      ),
    );
  }
}
