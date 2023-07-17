import 'package:auther_client/src/core/utils/error_util.dart';
import 'package:auther_client/src/core/utils/pattern_match.dart';
import 'package:auther_client/src/feature/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared/model.dart';

sealed class ProfileState extends _$ProfileStateBase {
  const ProfileState._({
    super.profile,
    super.error,
  });

  const factory ProfileState.idle({
    Profile? profile,
    String? error,
  }) = _ProfileState$Idle;

  const factory ProfileState.processing({
    Profile? profile,
    String? error,
  }) = _ProfileState$Processing;
}

final class _ProfileState$Idle extends ProfileState {
  const _ProfileState$Idle({
    super.profile,
    super.error,
  }) : super._();
}

final class _ProfileState$Processing extends ProfileState {
  const _ProfileState$Processing({
    super.profile,
    super.error,
  }) : super._();
}

@immutable
abstract base class _$ProfileStateBase {
  const _$ProfileStateBase({
    this.profile,
    this.error,
  });

  @nonVirtual
  final Profile? profile;

  @nonVirtual
  final String? error;

  bool get hasError => error != null;

  bool get hasProfile => profile != null;

  bool get isProcessing => maybeMap(
        processing: (_) => true,
        orElse: () => false,
      );
  
  bool get isIdling => maybeMap(
        idle: (_) => true,
        orElse: () => false,
      );

  R map<R>({
    required PatternMatch<R, _ProfileState$Idle> idle,
    required PatternMatch<R, _ProfileState$Processing> processing,
  }) =>
      switch (this) {
        final _ProfileState$Idle idleState => idle(idleState),
        final _ProfileState$Processing processingState =>
          processing(processingState),
        _ => throw UnsupportedError('Unsupported state: $this'),
      };

  R maybeMap<R>({
    required R Function() orElse,
    PatternMatch<R, _ProfileState$Idle>? idle,
    PatternMatch<R, _ProfileState$Processing>? processing,
  }) =>
      map(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
      );

  @override
  String toString() => 'ProfileState(profile: $profile, error: $error)';

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => Object.hash(profile, error);
}

sealed class ProfileEvent extends _$ProfileEventBase {
  const ProfileEvent._();

  const factory ProfileEvent.fetch() = _ProfileEvent$Fetch;
}

final class _ProfileEvent$Fetch extends ProfileEvent {
  const _ProfileEvent$Fetch() : super._();
}

@immutable
abstract base class _$ProfileEventBase {
  const _$ProfileEventBase();

  R map<R>({
    required PatternMatch<R, _ProfileEvent$Fetch> fetch,
  }) =>
      switch (this) {
        final _ProfileEvent$Fetch fetchEvent => fetch(fetchEvent),
        _ => throw UnsupportedError('Unsupported event: $this'),
      };

  R maybeMap<R>({
    required R Function() orElse,
    PatternMatch<R, _ProfileEvent$Fetch>? fetch,
  }) =>
      map(
        fetch: fetch ?? (_) => orElse(),
      );

  @override
  String toString() => 'ProfileEvent()';

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => 0;
}

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileRepository,
  }) : super(const ProfileState.idle()) {
    on<ProfileEvent>(
      (event, emit) => event.map(
        fetch: (e) => _fetch(e, emit),
      ),
    );
  }

  final ProfileRepository profileRepository;

  Future<void> _fetch(
    _ProfileEvent$Fetch event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.processing());
    try {
      final profileFromCache = profileRepository.getProfileFromCache();
      if (profileFromCache != null) {
        emit(ProfileState.idle(profile: profileFromCache));
      }
      final profile = await profileRepository.getProfileFromServer();
      emit(ProfileState.idle(profile: profile));
    } on Object catch (e) {
      emit(ProfileState.idle(error: ErrorUtil.formatError(e)));
      rethrow;
    }
  }
}
