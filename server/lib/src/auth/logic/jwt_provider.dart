import 'package:auther_server/src/common/exception/auth_exception.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/model.dart';

abstract interface class JWTProvider {
  TokenPair createTokenPair(int userId);

  int verifyRefreshToken(String refreshToken);
}

final class JWTProviderImpl implements JWTProvider {
  JWTProviderImpl({
    required this.secretKey,
  });

  final String secretKey;

  @override
  TokenPair createTokenPair(int userId) {
    final iat = DateTime.now().millisecondsSinceEpoch;
    final accessToken = JWT(
      {
        'userId': userId,
        'iat': iat,
        'exp': iat + Duration(minutes: 10).inMilliseconds,
      },
      issuer: 'auther',
      audience: Audience.one('auther client'),
    ).sign(SecretKey(secretKey));
    final refreshToken = JWT(
      {
        'userId': userId,
        'iat': iat,
        'exp': iat + Duration(days: 30).inMilliseconds,
      },
      issuer: 'auther',
      audience: Audience.one('auther client'),
    ).sign(SecretKey(secretKey));

    return (
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  int verifyRefreshToken(String refreshToken) {
    final jwt = JWT.verify(
      refreshToken,
      SecretKey(secretKey),
      issuer: 'auther',
      audience: Audience.one('auther client'),
    );

    if (jwt.payload
        case {
          'exp': int exp,
          'userId': int userId,
        }) {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp);

      if (expiresAt.isBefore(DateTime.now())) {
        throw AuthException$RefreshTokenExpired();
      }

      return userId;
    } else {
      throw AuthException$TokenMalformed();
    }
  }
}
