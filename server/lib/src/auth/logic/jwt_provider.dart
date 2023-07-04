import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/model.dart';

abstract interface class JWTProvider {
  TokenPair createTokenPair(int userId);
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
}
