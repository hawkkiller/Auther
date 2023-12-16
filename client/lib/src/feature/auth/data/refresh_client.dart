import 'package:dio/dio.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/oauth/refresh_client.dart';

/// Refresh client implementation
final class RefreshClientImpl implements RefreshClient {
  /// [Dio] instance for making network requests.
  final Dio client;

  /// Creates an instance of RefreshClientImpl.
  RefreshClientImpl({required this.client});

  @override
  Future<TokenPair> refreshToken(String refreshToken) async {
    final response = await client.get<Map<String, Object?>>(
      '/api/v1/auth/refresh',
      queryParameters: {'refreshToken': refreshToken},
    );

    if (response.data
        case {
          'data': {
            'accessToken': final String accessToken,
            'refreshToken': final String refreshToken
          }
        }) {
      return (
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    throw FormatException('Invalid response format. $response');
  }
}
