import 'dart:convert';

import 'package:auther_server/src/auth/logic/auth_service.dart';
import 'package:auther_server/src/common/exception/auth_exception.dart';
import 'package:auther_server/src/common/misc/app_response.dart';
import 'package:shared/model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Router for auth routes
class AuthRouter {
  AuthRouter();

  Handler createRouter() => Router()..post('/signup', _signUp);

  Future<Response> _signUp(Request request) async {
    final body = await request.readAsString().then(jsonDecode);

    try {
      if (body
          case {
            'email': String email,
            'password': String password,
            'username': String username,
          }) {
        final token = await request.auth.signUp(
          email: email,
          password: password,
          username: username,
        );

        return AppResponse.ok(
          statusCode: 200,
          body: {
            'accessToken': token.accessToken,
            'refreshToken': token.refreshToken,
          },
        );
      }
    } on AuthException catch (e) {
      return AppResponse.error(
        e.message.toString(),
        errorCode: e.errorCode,
        statusCode: e is AuthException$UserExists ? 409 : 400,
      );
    }

    return AppResponse.error(
      'Invalid body',
      errorCode: ErrorCode.invalidBody,
    );
  }
}

extension _AuthExtension on Request {
  AuthService get auth => context['authService'] as AuthService;
}
