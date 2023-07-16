import 'package:auther_client/src/feature/authentication/widget/sign_in_screen.dart';
import 'package:auther_client/src/feature/authentication/widget/sign_up_screen.dart';
import 'package:auther_client/src/feature/home/widget/home_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: HomeRoute.page),
      ];
}
