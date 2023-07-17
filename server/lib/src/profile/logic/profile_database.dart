import 'package:auther/src/common/database/database.dart';
import 'package:auther/src/common/exception/auth_exception.dart';
import 'package:shared/model.dart';

abstract interface class ProfileDatabase {
  /// Returns the current user's profile.
  Future<Profile> findMe(int id);
}

class ProfileDatabaseImpl implements ProfileDatabase {
  ProfileDatabaseImpl(this._database);

  final Database _database;

  @override
  Future<Profile> findMe(int id) async {
    final user = await (_database.select(_database.userTbl)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (user == null) {
      throw AuthException$TokenMalformed();
    }

    return Profile(
      username: user.username,
      email: user.email,
    );
  }
}
