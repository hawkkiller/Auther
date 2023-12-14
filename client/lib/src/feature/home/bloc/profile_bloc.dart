import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sizzle_starter/src/core/utils/mixins/set_state_mixin.dart';
import 'package:sizzle_starter/src/feature/home/data/profile_repository.dart';
import 'package:sizzle_starter/src/feature/home/model/profile.dart';

part 'profile_bloc.freezed.dart';

/// Events that can be dispatched to the [ProfileBloc].
@freezed
class ProfileEvent with _$ProfileEvent {
  /// Fetches the profile of the user.
  const factory ProfileEvent.fetchProfile() = _FetchProfileProfileEvent;
}

/// States that can be emitted by the [ProfileBloc].
@freezed
class ProfileState with _$ProfileState {

  const ProfileState._();

  /// Idle state.
  const factory ProfileState.idle({
    Profile? profile,
    Object? error,
  }) = _IdleProfileState;

  /// Processing state.
  const factory ProfileState.processing({
    Profile? profile,
  }) = _ProcessingProfileState;

  /// Returns whether the state is processing or not.
  bool get isProcessing => maybeMap(
        orElse: () => false,
        processing: (_) => true,
      );
}

/// Profile bloc that handles profile.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with SetStateMixin {
  /// Create an [ProfileBloc] instance.
  ProfileBloc(this._repository) : super(const ProfileState.idle()) {
    on<ProfileEvent>(
      (event, emit) => event.map(
        fetchProfile: (e) => _fetchProfile(e, emit),
      ),
    );
  }

  final ProfileRepository _repository;

  Future<void> _fetchProfile(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.processing());

    try {
      final profile = await _repository.fetchProfile();

      emit(ProfileState.idle(profile: profile));

      return;
    } on Exception catch (e) {
      emit(ProfileState.idle(error: e));
    }
  }
}
