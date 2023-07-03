import 'package:http_interceptor/http_interceptor.dart';
import 'package:sizzle_starter/src/feature/authentication/data/auth_data_provider.dart';

final class OAuthInterceptor extends InterceptorContract {
  OAuthInterceptor(this._accessor);

  final AuthTokenAccessor _accessor;

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) {
    final token = _accessor.getTokenPair();
    request.headers['Authorization'] = 'Bearer ${token?.accessToken}';
    return Future.sync(() => request);
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) =>
      Future.sync(() => response);
}

class OAuthRetryPolicy extends RetryPolicy {
  OAuthRetryPolicy(this._accessor);

  final OAuthAccessor _accessor;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    try {
      if (response.statusCode == 401) {
        final token = _accessor.getTokenPair()?.refreshToken;
        if (token == null) {
          await _accessor.signOut();
          return false;
        }
        await _accessor.refreshTokenPair();

        return true;
      }
      return false;
    } on Object {
      await _accessor.signOut();
      rethrow;
    }
  }
}
