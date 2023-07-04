import 'dart:convert';

import 'package:shared/model.dart';
import 'package:shelf/shelf.dart';

sealed class AppResponse {
  static Response error(
    String error, {
    required ErrorCode errorCode,
    int statusCode = 400,
    Map<String, String> headers = const {
      'content-type': 'application/json; charset=utf-8',
    },
  }) =>
      Response(
        statusCode,
        headers: headers,
        body: jsonEncode({
          'status': 'error',
          'error': {
            'code': errorCode.code,
            'message': error,
          },
        }),
      );

  static Response ok({
    int statusCode = 200,
    Map<String, String> headers = const {
      'content-type': 'application/json; charset=utf-8',
    },
    Map<String, Object>? body,
  }) =>
      Response(
        statusCode,
        headers: headers,
        body: body == null
            ? null
            : jsonEncode({
                'status': 'ok',
                'data': body,
              }),
      );
}
