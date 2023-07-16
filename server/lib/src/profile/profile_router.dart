import 'package:auther/src/common/exception/auth_exception.dart';
import 'package:auther/src/common/misc/app_response.dart';
import 'package:auther/src/common/router/router.dart';
import 'package:auther/src/profile/logic/profile_service.dart';
import 'package:shared/model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final class ProfileRouter implements IRouter {
  const ProfileRouter(this.profileService);

  final ProfileService profileService;

  @override
  Handler createRouter() => Router()..get('/me', _me);

  Future<Response> _me(Request request) async {
    final userId = request.userId;

    if (userId == null) {
      return AppResponse.error(
        'Failed to decode token',
        errorCode: ErrorCode.tokenMalformed,
      );
    }

    try {
      final profile = await profileService.findMe(userId);
      return AppResponse.ok(
        body: profile.toJson(),
      );
    } on AuthException catch (e) {
      return AppResponse.error(
        e.message.toString(),
        errorCode: e.errorCode,
      );
    }
  }
}

extension on Request {
  int? get userId => context['userId'] as int?;
}
