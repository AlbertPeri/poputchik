import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/settings/enum/theme_type.dart';
import 'package:companion/src/feature/settings/widget/scope/settings_scope.dart';
import 'package:flutter/material.dart';

/// {@template theme_button}
/// Кнопка выбора темы
/// {@endtemplate}
class ThemeButton extends StatelessWidget {
  /// {@macro theme_button}
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppTheme>(
      value: SettingsScope.appThemeOf(context),
      elevation: 16,
      onChanged: (theme) =>
          SettingsScope.setTheme(context, theme ?? AppTheme.system),
      items: [
        DropdownMenuItem(
          value: AppTheme.system,
          child: Text(context.localized.systemThemeLabel),
        ),
        DropdownMenuItem(
          value: AppTheme.light,
          child: Text(context.localized.lightThemeLabel),
        ),
        DropdownMenuItem(
          value: AppTheme.dark,
          child: Text(context.localized.darkThemeLabel),
        ),
      ],
    );
  }
}
