import 'package:auther/src/auth/model/jwt_payload.dart';
import 'package:auther/src/common/exception/auth_exception.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/model.dart';

abstract interface class JWTVerifier {
  JwtPayload verify(String token);
}

abstract interface class JWTCreator {
  TokenPair createTokenPair(int userId);
}

abstract interface class JWTProvider implements JWTVerifier, JWTCreator {}

final class JWTProviderImpl implements JWTProvider {
  JWTProviderImpl({
    required this.secretKey,
  });

  final String secretKey;

  @override
  JwtPayload verify(String accessToken) {
    final jwt = JWT.verify(
      accessToken,
      SecretKey(secretKey),
      issuer: 'auther',
      audience: Audience.one('auther client'),
    );

    if (jwt.payload
        case {
          'exp': int exp,
          'userId': int userId,
          'iat': int iat,
        }) {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp);

      if (expiresAt.isBefore(DateTime.now())) {
        throw AuthException$TokenExpired();
      }

      return JwtPayload(
        userId: userId,
        iat: iat,
        exp: exp,
      );
    }
    throw AuthException$TokenMalformed();
  }

  @override
  TokenPair createTokenPair(int userId) {
    final iat = DateTime.now().millisecondsSinceEpoch;
    final accessToken = JWT(
      JwtPayload(
        userId: userId,
        iat: iat,
        exp: iat + Duration(hours: 1).inMilliseconds,
      ).toJson(),
      issuer: 'auther',
      audience: Audience.one('auther client'),
    ).sign(SecretKey(secretKey));
    final refreshToken = JWT(
      JwtPayload(
        userId: userId,
        iat: iat,
        exp: iat + Duration(days: 7).inMilliseconds,
      ).toJson(),
      issuer: 'auther',
      audience: Audience.one('auther client'),
    ).sign(SecretKey(secretKey));

    return (
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
