import 'dart:io';
import 'dart:isolate';

import 'package:auther_server/src/auth/logic/auth_database.dart';
import 'package:auther_server/src/auth/logic/auth_service.dart';
import 'package:auther_server/src/auth/logic/jwt_provider.dart';
import 'package:auther_server/src/common/database/database.dart';
import 'package:auther_server/src/common/middleware/injector.dart';
import 'package:auther_server/src/common/middleware/json_content_type_response.dart';
import 'package:auther_server/src/common/middleware/request_logger.dart';
import 'package:auther_server/src/common/router/router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;

final class SharedServer {
  SharedServer({
    required this.port,
    required this.name,
    required this.router,
    required this.databaseConnection,
  });

  final int port;
  final String name;
  final ApiRouter router;
  final DriftIsolate databaseConnection;

  Future<Isolate> call() => Isolate.spawn(
        _startServer,
        this,
      );

  static Future<void> _startServer(SharedServer arg) async {
    final db = Database.connect(
      await arg.databaseConnection.connect(),
    );
    final secretKey = Platform.environment['SECRET_KEY'] ??
        (throw Exception('SECRET_KEY not found'));
    final authService = AuthServiceImpl(
      authDatabase: AuthDatabaseImpl(db),
      jwtProvider: JWTProviderImpl(secretKey: secretKey),
    );

    final pipeline = shelf.Pipeline()
        .addMiddleware(jsonContentTypeResponse())
        .addMiddleware($requestLogger())
        .addMiddleware(injector({
          'database': db,
          'authService': authService,
        }))
        .addHandler(arg.router.createRouter());
    await shelf_io.serve(
      pipeline,
      InternetAddress.anyIPv4,
      arg.port,
      shared: true,
    );
  }
}
