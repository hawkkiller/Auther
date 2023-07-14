import 'dart:convert';
import 'dart:io';

import 'package:auther/src/auth/auth_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiRouter {
  ApiRouter({
    required this.authRouter,
  });

  final AuthRouter authRouter;

  Handler createRouter() {
    final rootRouter = Router(notFoundHandler: _$notFound);

    rootRouter.mount('/api/auth/', authRouter.createRouter());
    rootRouter.get('/healthz', _$healthz);

    return rootRouter;
  }
}

Response _$healthz(Request request) => Response.ok(
      jsonEncode(<String, Object?>{
        'status': 'ok',
      }),
      headers: <String, String>{
        'Content-Type': ContentType.json.value,
      },
    );

Response _$notFound(Request request) => Response.notFound(
      jsonEncode(<String, Object?>{
        'error': <String, Object?>{
          'status': HttpStatus.notFound,
          'message': 'Not Found',
          'details': <String, Object?>{
            'path': request.url.path,
            'method': request.method,
            'headers': request.headers,
          },
        },
      }),
      headers: <String, String>{
        'Content-Type': ContentType.json.value,
      },
    );
