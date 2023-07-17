import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:rest_client/src/rest_client_base.dart';

@immutable
abstract class RestClient {
  factory RestClient(Dio dio) = RestClientBase;

  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  });

  Future<Map<String, Object?>> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  });

  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  });

  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  });

  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  });
}
