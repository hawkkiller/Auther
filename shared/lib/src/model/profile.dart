import 'package:meta/meta.dart';

@immutable
final class Profile {
  const Profile({
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  factory Profile.fromJson(Map<String, Object?> json) => Profile(
        username: json['username']! as String,
        email: json['email']! as String,
      );

  Map<String, Object?> toJson() => {
        'username': username,
        'email': email,
      };

  @override
  String toString() => 'Profile(username: $username, email: $email)';
}
