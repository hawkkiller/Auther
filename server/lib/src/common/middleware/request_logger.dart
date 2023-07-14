import 'package:auther/src/common/misc/app_response.dart';
import 'package:shared/model.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware $requestLogger() => (innerHandler) {
      return (request) async {
        try {
          return await shelf.logRequests()(innerHandler)(request);
        } on FormatException catch (e) {
          return AppResponse.error(
            'Invalid body: ${e.message}',
            errorCode: ErrorCode.invalidBody,
          );
        } on Object catch (e) {
          return AppResponse.error(e.toString(), errorCode: ErrorCode.unknown);
        }
      };
    };
