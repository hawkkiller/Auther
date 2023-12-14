import 'package:async/async.dart';
import 'package:sizzle_starter/src/feature/home/data/profile_datasource.dart';
import 'package:sizzle_starter/src/feature/home/model/profile.dart';

/// Profile repository
abstract interface class ProfileRepository {
  /// Fetches the profile of the user
  Future<Profile> fetchProfile();
}

/// Profile repository implementation.
final class ProfileRepositoryImpl implements ProfileRepository {
  /// Creates an instance of ProfileRepositoryImpl.
  ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  final _cache = AsyncCache<Profile>(
    const Duration(minutes: 5),
  );

  @override
  Future<Profile> fetchProfile() => _cache.fetch(
        () => _dataSource.fetchProfile(),
      );
}
