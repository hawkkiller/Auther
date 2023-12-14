import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/feature/home/model/profile.dart';

/// Profile data source.
abstract interface class ProfileDataSource {
  /// Fetches the profile of the user
  Future<Profile> fetchProfile();
}

/// Profile data source implementation.
final class ProfileDataSourceImpl implements ProfileDataSource {
  /// Creates an instance of ProfileDataSourceImpl.
  ProfileDataSourceImpl(this._client);

  final RestClient _client;

  @override
  Future<Profile> fetchProfile() async {
    final response = await _client.get('/api/v1/profile/me');

    if (response
        case {
          'username': final String username,
          'email': final String email,
        }) {
      return Profile(
        username: username,
        email: email,
      );
    }
    throw FormatException('Invalid response format. $response');
  }
}
