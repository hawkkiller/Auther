import 'package:auther/src/common/misc/jwt_provider.dart';
import 'package:auther/src/common/misc/app_response.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/model.dart';
import 'package:shelf/shelf.dart';

Middleware $decodeJwt(JWTVerifier jwt) => (innerHandler) {
      return (request) async {
        final bearer = request.headers['Authorization']?.split(' ');

        if (bearer == null || bearer.length != 2) {
          return AppResponse.error(
            'Missing or malformed token',
            errorCode: ErrorCode.tokenMalformed,
            statusCode: 401,
          );
        }

        final token = bearer[1];

        try {
          final payload = jwt.verify(token);
          request = request.change(context: {
            'userId': payload.userId,
            ...request.context,
          });
          return innerHandler(request);
        } on JWTExpiredException {
          return AppResponse.error(
            'Token expired',
            errorCode: ErrorCode.tokenExpired,
            statusCode: 401,
          );
        }
        on Object catch (e) {
          return AppResponse.error(
            'Failed to decode token: $e',
            errorCode: ErrorCode.tokenMalformed,
            statusCode: 401,
          );
        }
      };
    };
