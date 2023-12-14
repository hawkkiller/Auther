import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// Profile model.
@freezed
class Profile with _$Profile {
  /// Default constructor.
  const factory Profile({
    required String email,
    required String username,
  }) = _Profile;

  /// Creates a [Profile] from a JSON object.
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
