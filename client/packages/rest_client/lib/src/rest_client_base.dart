import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/src/exception/network_exception.dart';
import 'package:rest_client/src/rest_client.dart';

base class RestClientBase implements RestClient {
  RestClientBase(this._client);

  final Dio _client;

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'GET',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'POST',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'PUT',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'DELETE',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'PATCH',
        headers: headers,
        queryParams: queryParams,
      );

  Future<Map<String, Object?>> _send(
    String path, {
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    try {
      final request = buildRequest(
        method: method,
        path: path,
        queryParams: queryParams,
        headers: headers,
        body: body,
      );
      final response = await _client.fetch<Map<String, Object?>>(request);

      if (response.statusCode! > 199 && response.statusCode! < 300) {
        return decodeResponse(response);
      }

      throw UnsupportedError('Unsupported statusCode: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw RestClientException(
          message: 'Connection timeout',
          statusCode: e.response?.statusCode,
        );
      }
      final response = e.response;

      if (response == null) {
        throw RestClientException(
          message: 'Unknown error',
          statusCode: e.response?.statusCode,
        );
      }

      if (response.statusCode! > 499) {
        if (response.data case {'error': {'message': final String message}}) {
          throw InternalServerException(
            statusCode: response.statusCode,
            message: message,
          );
        }
        throw InternalServerException(
          statusCode: response.statusCode,
          message: 'Internal server error',
        );
      } else if (response.statusCode! > 399) {
        if (response.data case {'error': {'message': final String message}}) {
          throw RestClientException(
            statusCode: response.statusCode,
            message: message,
          );
        }
        throw RestClientException(
          statusCode: response.statusCode,
          message: 'Client error',
        );
      }

      Error.throwWithStackTrace(
        UnsupportedError('Unsupported statusCode: ${response.statusCode}'),
        e.stackTrace,
      );
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Unsupported error: $e'),
        stackTrace,
      );
    }
  }

  @protected
  @visibleForTesting
  Map<String, Object?> decodeResponse(Response<Map<String, Object?>> response) {
    final contentType =
        response.headers['content-type'] ?? response.headers['Content-Type'];
    if (contentType.toString().contains('application/json')) {
      final json = response.data ?? const {};
      try {
        if (json case {'error': {'message': final String message}}) {
          throw RestClientException(
            message: message,
            statusCode: response.statusCode,
          );
        }
        if (json case {'data': final Map<String, Object?> data}) {
          return data;
        }
        return json;
      } on Object catch (error, stackTrace) {
        if (error is NetworkException) rethrow;

        Error.throwWithStackTrace(
          InternalServerException(
            message: 'Server returned invalid json: $error',
          ),
          StackTrace.fromString(
            '$stackTrace\n'
            'Body: "${json.toString().length > 100 ? '${json.toString().substring(0, 100)}...' : json}"',
          ),
        );
      }
    } else {
      Error.throwWithStackTrace(
        InternalServerException(
          message: 'Server returned invalid content type: $contentType',
          statusCode: response.statusCode,
        ),
        StackTrace.fromString(
          '${StackTrace.current}\n'
          'Headers: "${jsonEncode(response.headers.map)}"',
        ),
      );
    }
  }

  @protected
  @visibleForTesting
  RequestOptions buildRequest({
    required String method,
    required String path,
    Map<String, Object?>? queryParams,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
  }) {
    final request = RequestOptions(
      method: method,
      path: path,
      baseUrl: _client.options.baseUrl,
      queryParameters: queryParams,
      headers: headers,
      data: jsonEncode(body),
    );
    request.headers.addAll({
      if (body != null) ...{
        'Content-Type': 'application/json;charset=utf-8',
      },
      'Connection': 'Keep-Alive',
      // the same as `"Cache-Control": "no-cache"`, but deprecated
      // however, to support older servers that tie to HTTP/1.0 this should
      // be included. According to RFC this header can be included and used
      // by the server even if it is HTTP/1.1+
      'Pragma': 'no-cache',
      'Accept': 'application/json',
      ...?headers?.map((key, value) => MapEntry(key, value.toString())),
    });
    return request;
  }
}
