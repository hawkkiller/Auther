import 'package:meta/meta.dart';

/// Profile
@immutable
final class Profile {
  /// Creates an instance of Profile.
  const Profile({
    required this.username,
    required this.email,
  });

  /// Username
  final String username;

  /// Email
  final String email;

  @override
  String toString() => 'Profile(username: $username, email: $email)';
}
