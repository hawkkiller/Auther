import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';
import 'package:sizzle_starter/src/feature/auth/widget/auth_scope.dart';
import 'package:sizzle_starter/src/feature/home/bloc/profile_bloc.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProfileBloc profileBloc;

  @override
  void initState() {
    profileBloc = ProfileBloc(DependenciesScope.of(context).profileRepository);
    super.initState();
  }

  void _loadProfile() => profileBloc.add(const ProfileEvent.fetchProfile());

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }

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
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              bloc: profileBloc,
              builder: (context, state) {
                final profile = state.profile;

                return Row(
                  children: [
                    if (profile != null) ...[
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          profile.username.isEmpty
                              ? ''
                              : profile.username[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        profile.username,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ] else ...[
                      const Text('No profile loaded'),
                    ],
                    const Spacer(),
                    TextButton(
                      onPressed: _loadProfile,
                      child: const Text('Load profile'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
}
