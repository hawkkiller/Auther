import 'package:auther_client/src/feature/authentication/data/auth_data_provider.dart';
import 'package:dio/dio.dart';

base class OAuthInterceptor extends QueuedInterceptor {
  OAuthInterceptor(this.authLogic);

  final AuthLogic authLogic;
  final client = Dio();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If token is expired, refresh it and save it to the storage
    // Then, repeat the original request
    if (err.response?.statusCode != 401) {
      try {
        final token = await authLogic.refreshTokenPair();
        final options = err.requestOptions.copyWith(
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer ${token.accessToken}',
          },
        );
        final response = await client.fetch<dynamic>(options);
        handler.resolve(response);
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          // await authLogic.signOut();
          handler.reject(e);
        } else {
          handler.next(e);
        }
      }
    } else {
      handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Authorization header to each request
    // Also, it would be a good idea to decode token here and check whether it is expired
    // If it is expired, refresh it and save it to the storage to avoid unnecessary requests
    final pair = authLogic.getTokenPair();
    options.headers['Authorization'] = 'Bearer ${pair?.accessToken}';
    handler.next(options);
  }
}
