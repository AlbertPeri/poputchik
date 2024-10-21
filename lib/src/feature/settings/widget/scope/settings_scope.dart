import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/settings/bloc/settings_bloc.dart';
import 'package:companion/src/feature/settings/enum/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure/pure.dart';

AppTheme _theme(SettingsState state) => state.data.themeType;

ThemeMode _themeToThemeMode(AppTheme theme) => theme.when(
      light: () => ThemeMode.light,
      dark: () => ThemeMode.dark,
      system: () => ThemeMode.system,
    );

class SettingsScope extends StatelessWidget {
  const SettingsScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const BlocScope<SettingsEvent, SettingsState, SettingsBloc> _scope =
      BlocScope();

  // --- Data --- //

  static ScopeData<ThemeMode> get themeModeOf =>
      _themeToThemeMode.dot(_theme).pipe(_scope.select);

  static ScopeData<AppTheme> get appThemeOf => _scope.select(_theme);

  // --- Methods --- //

  static UnaryScopeMethod<AppTheme> get setTheme => _scope.unary(
        (context, theme) => SettingsEvent.setTheme(themeType: theme),
      );

  // --- Build --- //

  @override
  Widget build(BuildContext context) => BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(
          settingsRepository: context.repository.settingsRepository,
        ),
        child: child,
      );
}
