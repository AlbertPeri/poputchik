import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/router/app_router_builder.dart';
import 'package:companion/src/feature/settings/widget/scope/settings_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = SettingsScope.themeModeOf(context, listen: true);

    return AppRouterBuilder(
      builder: (context, config) => MaterialApp.router(
        builder: FToastBuilder(),
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.lightTheme,
        onGenerateTitle: (context) => context.localized.appName,
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: config,
      ),
    );
  }
}
