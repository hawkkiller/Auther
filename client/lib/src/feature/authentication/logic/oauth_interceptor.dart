import 'package:dio/dio.dart';
import 'package:shared/model.dart';

base class OAuthInterceptor extends QueuedInterceptor {
  OAuthInterceptor({
    required this.refresh,
    required this.loadTokens,
    required this.clearTokens,
  });

  final Future<TokenPair> Function() refresh;
  final TokenPair? Function() loadTokens;
  final Future<void> Function() clearTokens;
  final client = Dio();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If token is expired, refresh it and save it to the storage
    // Then, repeat the original request
    if (err.response?.statusCode == 401) {
      try {
        final token = await refresh();
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
          // await clearTokens();
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
    final pair = loadTokens();
    options.headers['Authorization'] = 'Bearer ${pair?.accessToken}';
    handler.next(options);
  }
}
