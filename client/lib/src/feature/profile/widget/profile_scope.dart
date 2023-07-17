import 'package:auther_client/src/core/utils/mixin/scope_mixin.dart';
import 'package:auther_client/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:auther_client/src/feature/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared/model.dart';

abstract mixin class ProfileController {
  /// Load profile of current user
  void loadProfile();

  abstract final Profile? profile;

  abstract final String? error;
}

class ProfileScope extends StatefulWidget {
  const ProfileScope({required this.child, super.key});

  final Widget child;

  static ProfileController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_InheritedProfile>(
        context,
        listen: listen,
      ).controller;

  @override
  State<ProfileScope> createState() => _ProfileScopeState();
}

class _ProfileScopeState extends State<ProfileScope> with ProfileController {
  late final ProfileBloc _profileBloc;

  ProfileState? _state;

  @override
  void initState() {
    _profileBloc = ProfileBloc(
      profileRepository:
          DependenciesScope.of(context).dependencies.profileRepository,
    )..stream.listen(_onProfileStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  void _onProfileStateChanged(ProfileState state) {
    if (!identical(state, _state)) {
      setState(() => _state = state);
    }
  }

  @override
  String? get error => _state?.error;

  @override
  Widget build(BuildContext context) => _InheritedProfile(
        controller: this,
        state: _state,
        child: widget.child,
      );

  @override
  void loadProfile() => _profileBloc.add(const ProfileEvent.fetch());

  @override
  Profile? get profile => _state?.profile;
}

class _InheritedProfile extends InheritedWidget {
  const _InheritedProfile({
    required this.controller,
    required this.state,
    required super.child,
  });

  final ProfileState? state;

  final ProfileController controller;

  @override
  bool updateShouldNotify(_InheritedProfile oldWidget) =>
      state != oldWidget.state;
}
