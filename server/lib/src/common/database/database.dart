import 'dart:developer';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart' as ffi;
import 'package:meta/meta.dart';

export 'package:drift/drift.dart' hide DatabaseOpener;
export 'package:drift/isolate.dart';

part 'database.g.dart';

@DriftDatabase(
  include: <String>{'tables/user.drift'},
)
class Database extends _$Database
    implements GeneratedDatabase, DatabaseConnectionUser, QueryExecutorUser {
  /// Creates a database that will store its result in the [path], creating it
  /// if it doesn't exist.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database.lazy({
    required io.File file,
    ffi.DatabaseSetup? setup,
    bool logStatements = false,
    bool dropDatabase = true,
  }) : super(
          LazyDatabase(
            () => _opener(
              file: file,
              setup: setup,
              logStatements: logStatements,
              dropDatabase: dropDatabase,
            ),
          ),
        );

  /// Creates a database from an existing [executor].
  Database.connect(super.connection);

  static Future<QueryExecutor> _opener({
    required io.File file,
    ffi.DatabaseSetup? setup,
    bool logStatements = false,
    bool dropDatabase = false,
  }) async {
    try {
      if ((dropDatabase) && file.existsSync()) {
        await file.delete();
      }
    } on Object catch (e, st) {
      log(
        "Can't delete database file: $file",
        level: 900,
        name: 'database',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
    return ffi.NativeDatabase.createInBackground(
      file,
      logStatements: logStatements,
      setup: setup,
    );
  }

  /// Creates an in-memory database won't persist its changes on disk.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database.memory({
    ffi.DatabaseSetup? setup,
    bool logStatements = false,
  }) : super(
          ffi.NativeDatabase.memory(
            logStatements: logStatements,
            setup: setup,
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => DatabaseMigrationStrategy(
        database: this,
      );
}

/// Handles database migrations by delegating work to [OnCreate] and [OnUpgrade]
/// methods.
@immutable
class DatabaseMigrationStrategy implements MigrationStrategy {
  /// Construct a migration strategy from the provided [onCreate] and
  /// [onUpgrade] methods.
  const DatabaseMigrationStrategy({
    required Database database,
  }) : _db = database;

  /// Database to use for migrations.
  final Database _db;

  /// Executes when the database is opened for the first time.
  @override
  OnCreate get onCreate => (m) async {
        //await _db.customStatement('PRAGMA writable_schema=ON;');
        await m.createAll();
      };

  /// Executes when the database has been opened previously, but the last access
  /// happened at a different [GeneratedDatabase.schemaVersion].
  /// Schema version upgrades and downgrades will both be run here.
  @override
  OnUpgrade get onUpgrade => (m, from, to) async {
        //await _db.customStatement('PRAGMA writable_schema=ON;');
        return _update(_db, m, from, to);
      };

  /// Executes after the database is ready to be used (ie. it has been opened
  /// and all migrations ran), but before any other queries will be sent. This
  /// makes it a suitable place to populate data after the database has been
  /// created or set sqlite `PRAGMAS` that you need.
  @override
  OnBeforeOpen get beforeOpen => (details) async {};

  /// https://moor.simonbinder.eu/docs/advanced-features/migrations/
  static Future<void> _update(Database db, Migrator m, int from, int to) async {
    m.createAll();
    if (from >= to) return;
  }
}
