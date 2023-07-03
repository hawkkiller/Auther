final class User {
  const User({
    required this.isAnonymous,
    this.email,
  });

  final String? email;
  final bool isAnonymous;
}
