import 'package:auther/src/profile/logic/profile_database.dart';
import 'package:shared/src/model/profile.dart';

abstract interface class ProfileService {
  /// Returns the current user's profile.
  Future<Profile> findMe(int id);
}

class ProfileServiceImpl implements ProfileService {
  ProfileServiceImpl({
    required this.database,
  });

  final ProfileDatabase database;

  @override
  Future<Profile> findMe(int id) async {
    final user = await database.findMe(id);

    return Profile(
      username: user.username,
      email: user.email,
    );
  }
}