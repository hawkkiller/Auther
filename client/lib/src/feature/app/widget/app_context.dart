import 'package:auther_client/src/core/localization/app_localization.dart';
import 'package:auther_client/src/core/router/app_router_scope.dart';
import 'package:auther_client/src/core/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  @override
  Widget build(BuildContext context) {
    final router = AppRouterScope.of(context);
    return MaterialApp.router(
      routerConfig: router.config(),
      supportedLocales: Localization.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        Localization.delegate,
      ],
      theme: lightThemeData,
      darkTheme: darkThemeData,
      // TODO(mlazebny): implement locale change.
      locale: const Locale('en', 'US'),
    );
  }
}
