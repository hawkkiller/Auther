import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/utils/preferences_dao.dart';

/// Auth data source
abstract interface class AuthDataSource {
  /// Sign in with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign out the current user.
  Future<void> signOut();
}

/// Auth source implementation
final class AuthDataSourceImpl
    with PreferencesDao
    implements AuthDataSource, TokenStorage {
  /// Create an [AuthDataSourceImpl] instance.
  AuthDataSourceImpl({
    required RestClient client,
    required this.sharedPreferences,
  }) : _client = client;

  final RestClient _client;

  @override
  final SharedPreferences sharedPreferences;

  late final _accessToken = stringEntry('access_token');

  late final _refreshToken = stringEntry('refresh_token');

  final _controller = StreamController<TokenPair?>.broadcast();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/signin',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response == null) throw Exception('Invalid response');

    final accessToken = response['accessToken']! as String;
    final refreshToken = response['refreshToken']! as String;

    await saveTokenPair(
      (
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/signup',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response == null) throw Exception('Invalid response');

    final accessToken = response['accessToken']! as String;
    final refreshToken = response['refreshToken']! as String;

    await saveTokenPair(
      (
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  Future<void> signOut() => clearTokenPair();

  @override
  Future<void> clearTokenPair() async {
    await _accessToken.remove();
    await _refreshToken.remove();
    _controller.add(null);
  }

  @override
  Future<TokenPair?> loadTokenPair() async {
    final accessToken = _accessToken.read();
    final refreshToken = _refreshToken.read();

    if (accessToken == null || refreshToken == null) return null;

    return (
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> saveTokenPair(TokenPair tokenPair) async {
    await _accessToken.set(tokenPair.accessToken);
    await _refreshToken.set(tokenPair.refreshToken);
    _controller.add(tokenPair);
  }

  @override
  Stream<TokenPair?> getTokenPairStream() => _controller.stream;
}
