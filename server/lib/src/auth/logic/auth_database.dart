import 'package:auther_server/src/common/database/database.dart';
import 'package:auther_server/src/common/exception/auth_exception.dart';

abstract interface class AuthDatabase {
  /// Returns the user id if signUp was successful.
  Future<int> signUp({
    required String username,
    required String password,
    required String email,
  });

  /// Returns the user id if verifyCredentials was successful.
  Future<int> verifyCredentials({
    required String email,
    required String password,
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
        throw AuthException$UserNotFound();
      }

      final user = await _database.into(_database.userTbl).insertReturning(
            UserTblCompanion.insert(
              username: username,
              password: password,
              email: email,
            ),
          );
      return user.id;
    } on AuthException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        AuthException$UnknownDatabaseError(e),
        stackTrace,
      );
    }
  }

  @override
  Future<int> verifyCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final user = await (_database.select(_database.userTbl)
            ..where((tbl) => tbl.email.equals(email)))
          .getSingle();

      if (user.password != password) {
        throw AuthException$UserNotFound();
      }

      return user.id;
    } on AuthException {
      rethrow;
    } on StateError {
      throw AuthException$UserNotFound();
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        AuthException$UnknownDatabaseError(e),
        stackTrace,
      );
    }
  }
}
