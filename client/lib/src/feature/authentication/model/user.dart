import 'package:meta/meta.dart';

@immutable
final class User {
  const User({
    required this.isAnonymous,
    this.email,
  });

  final String? email;
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          isAnonymous == other.isAnonymous;

  @override
  int get hashCode => email.hashCode ^ isAnonymous.hashCode;
}
