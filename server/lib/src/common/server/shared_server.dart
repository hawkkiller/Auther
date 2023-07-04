import 'dart:io';
import 'dart:isolate';

import 'package:auther_server/src/common/router/router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;

final class SharedServer {
  SharedServer({
    required this.port,
    required this.name,
    required this.router,
  });

  final int port;
  final String name;
  final ApiRouter router;

  Future<Isolate> call() => Isolate.spawn(
        _startServer,
        this,
      );

  static Future<void> _startServer(SharedServer arg) async {
    final pipeline = shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(arg.router.createRouter());
    await shelf_io.serve(
      pipeline,
      InternetAddress.anyIPv4,
      arg.port,
      shared: true,
    );
  }
}
