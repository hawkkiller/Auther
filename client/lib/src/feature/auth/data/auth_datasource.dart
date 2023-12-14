import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
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

/// AuthDataSourceImpl provides authentication data services.
final class AuthDataSourceImpl
    with PreferencesDao
    implements AuthDataSource, TokenStorage {
  /// [Dio] instance for making network requests.
  final Dio client;

  /// SharedPreferences instance for local storage access.
  @override
  final SharedPreferences sharedPreferences;

  /// Creates an instance of AuthDataSourceImpl.
  AuthDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  late final _accessToken = stringEntry('access_token');
  late final _refreshToken = stringEntry('refresh_token');
  final _controller = StreamController<TokenPair?>.broadcast();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await client.post<Map<String, Object?>>(
      '/api/v1/auth/signin',
      data: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    await _handleAuthResponse(response.data);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await client.post<Map<String, Object?>>(
      '/api/v1/auth/signup',
      data: {
        'email': email,
        'password': password,
      },
    );
    await _handleAuthResponse(response.data);
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
    return (accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> saveTokenPair(TokenPair tokenPair) async {
    await _accessToken.set(tokenPair.accessToken);
    await _refreshToken.set(tokenPair.refreshToken);
    _controller.add(tokenPair);
  }

  @override
  Stream<TokenPair?> getTokenPairStream() => _controller.stream;

  /// Handles the authentication response.
  Future<void> _handleAuthResponse(Map<String, Object?>? response) async {
    if (response
        case {
          'data': {
            'accessToken': final String accessToken,
            'refreshToken': final String refreshToken,
          }
        }) {
      await saveTokenPair(
        (accessToken: accessToken, refreshToken: refreshToken),
      );
      return;
    }

    throw FormatException('Invalid response format. $response');
  }
}
