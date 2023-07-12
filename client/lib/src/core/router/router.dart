import 'package:auther_client/src/feature/sample/widget/sample_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SampleRoute.page, path: '/'),
      ];
}
