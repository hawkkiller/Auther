import 'dart:io';
import 'dart:isolate';

import 'package:auther/src/auth/auth_router.dart';
import 'package:auther/src/auth/logic/auth_database.dart';
import 'package:auther/src/auth/logic/auth_service.dart';
import 'package:auther/src/common/middleware/jwt_middleware.dart';
import 'package:auther/src/common/misc/jwt_provider.dart';
import 'package:auther/src/common/database/database.dart';
import 'package:auther/src/common/middleware/json_content_type_response.dart';
import 'package:auther/src/common/middleware/request_logger.dart';
import 'package:auther/src/common/router/router.dart';
import 'package:auther/src/profile/logic/profile_database.dart';
import 'package:auther/src/profile/logic/profile_service.dart';
import 'package:auther/src/profile/profile_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;

final class SharedServer {
  SharedServer({
    required this.port,
    required this.name,
    required this.databaseConnection,
  });

  final int port;
  final String name;
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

    final jwtProvider = JWTProviderImpl(secretKey: secretKey);
    final authService = AuthServiceImpl(
      authDatabase: AuthDatabaseImpl(db),
      jwtProvider: jwtProvider,
    );

    final profileService = ProfileServiceImpl(
      database: ProfileDatabaseImpl(db),
    );

    final authRouter = AuthRouter(authService).createRouter();

    final profileRouter = ProfileRouter(profileService).createRouter();

    final router = ApiRouter(
      authRouter: authRouter,
      profileRouter: shelf.Pipeline()
          .addMiddleware($decodeJwt(jwtProvider))
          .addHandler(profileRouter),
    );

    final pipeline = shelf.Pipeline()
        .addMiddleware(jsonContentTypeResponse())
        .addMiddleware($requestLogger())
        .addHandler(router.createRouter());
    await shelf_io.serve(
      pipeline,
      InternetAddress.anyIPv4,
      arg.port,
      shared: true,
    );
  }
}
