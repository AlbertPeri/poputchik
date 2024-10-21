import 'package:companion/src/core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BuildContextX on BuildContext {
  IDependenciesStorage get dependencies => DependenciesScope.of(this);

  Dio get dio => dependencies.dio;

  AppDatabase get database => dependencies.database;

  SharedPreferences get sharedPreferences => dependencies.sharedPreferences;

  IToastService get toastService => dependencies.toastService;

  ILocationService get locationService => dependencies.locationService;

  IRepositoryStorage get repository => RepositoryScope.of(this);

  AppLocalizations get localized => AppLocalizations.of(this);

  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  double calculateMapViewHeight() {
    final deviceHeight = MediaQuery.sizeOf(this).height;
    final padding = MediaQuery.of(this).padding;
    final mapViewHeight = deviceHeight - padding.top - padding.bottom;
    return mapViewHeight;
  }
}
