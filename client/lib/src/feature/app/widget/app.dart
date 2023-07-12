import 'package:auther_client/src/core/router/app_router_scope.dart';
import 'package:auther_client/src/core/widget/scope_widgets.dart';
import 'package:auther_client/src/feature/app/widget/app_context.dart';
import 'package:auther_client/src/feature/initialization/model/dependencies.dart';
import 'package:auther_client/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A widget which is responsible for running the app.
class App extends StatelessWidget {
  const App({
    required this.result,
    super.key,
  });

  void run() => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: this,
        ),
      );

  final InitializationResult result;

  @override
  Widget build(BuildContext context) => ScopesProvider(
        providers: [
          ScopeProvider(
            buildScope: (child) => DependenciesScope(
              dependencies: result.dependencies,
              child: child,
            ),
          ),
          ScopeProvider(
            buildScope: (child) => AppRouterScope(
              child: child,
            ),
          ),
        ],
        child: const AppContext(),
      );
}
