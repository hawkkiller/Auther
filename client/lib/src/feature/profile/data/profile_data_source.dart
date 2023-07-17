import 'dart:convert';

import 'package:rest_client/rest_client.dart';
import 'package:shared/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ProfileDataSource {
  /// Loads profile from server.
  Future<Profile> loadProfileFromServer();

  /// Loads profile from cache.
  /// If there is no profile in cache, returns null.
  Profile? loadProfileFromCache();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  ProfileDataSourceImpl({
    required this.restClient,
    required this.sharedPreferences,
  });

  final RestClient restClient;
  final SharedPreferences sharedPreferences;

  @override
  Future<Profile> loadProfileFromServer() async {
    final response = await restClient.get('/api/v1/profile/me');
    sharedPreferences.setString('profile', jsonEncode(response)).ignore();
    return Profile.fromJson(response);
  }

  @override
  Profile? loadProfileFromCache() {
    final profileJson = sharedPreferences.getString('profile');
    if (profileJson == null) return null;
    return Profile.fromJson(jsonDecode(profileJson) as Map<String, Object?>);
  }
}
