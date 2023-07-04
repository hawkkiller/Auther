import 'package:auther_server/src/common/database/database.dart';
import 'package:auther_server/src/common/exception/auth_exception.dart';

abstract interface class AuthDatabase {
  /// Returns the user id if signUp was successful.
  Future<int> signUp({
    required String username,
    required String password,
    required String email,
  });
}

final class AuthDatabaseImpl implements AuthDatabase {
  AuthDatabaseImpl(this._database);

  final Database _database;

  @override
  Future<int> signUp({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final userExists = await (_database.select(_database.userTbl)
            ..where((tbl) => tbl.username.equals(username)))
          .getSingleOrNull();

      if (userExists != null) {
        throw AuthException$UserExists();
      }

      final userId = await _database.into(_database.userTbl).insert(
            UserTblCompanion.insert(
              username: username,
              password: password,
              email: email,
            ),
          );
      return userId;
    } on AuthException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        AuthException$UnknownDatabaseError(e),
        stackTrace,
      );
    }
  }
}
