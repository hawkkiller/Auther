import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract interface class IRouter {
  Handler createRouter();
}

class ApiRouter implements IRouter {
  ApiRouter({
    required this.authRouter,
    required this.profileRouter,
  });

  final Handler authRouter;
  final Handler profileRouter;

  @override
  Handler createRouter() => Router(notFoundHandler: _$notFound)
    ..mount('/api/v1/auth', authRouter)
    ..mount('/api/v1/profile', profileRouter)
    ..get('/healthz', _$healthz);
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
