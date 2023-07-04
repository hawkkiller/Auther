import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:auther_server/src/auth/auth_router.dart';
import 'package:auther_server/src/common/router/router.dart';
import 'package:auther_server/src/common/server/shared_server.dart';
import 'package:l/l.dart';

void main(List<String> args) => runZonedGuarded(
      () async {
        final cpuCount = math.max(Platform.numberOfProcessors, 2);
        final port = 8080;
        final apiRouter = ApiRouter(
          authRouter: AuthRouter(),
        );
        for (var i = 0; i < cpuCount; i++) {
          final receivePort = ReceivePort();
          // ignore: unused_local_variable
          SendPort? sendPort;
          final isolate = SharedServer(
            port: port,
            name: 'Server ${i + 1}',
            router: apiRouter,
          );
          await isolate();
          receivePort.listen(
            (Object? message) {
              if (message case SendPort s) sendPort = s;
            },
            cancelOnError: false,
          );
        }
        l.i('Started $cpuCount servers on port $port');
      },
      l.e,
    );
