import 'package:companion/src/feature/settings/database/settings_dao.dart';
import 'package:companion/src/feature/settings/enum/theme_type.dart';
import 'package:companion/src/feature/settings/model/settings_data.dart';
import 'package:pure/pure.dart';

abstract class ISettingsRepository {
  SettingsData currentData();

  Future<void> setTheme(AppTheme value);
}

class SettingsRepository implements ISettingsRepository {
  SettingsRepository({
    required ISettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  final ISettingsDao _settingsDao;

  AppTheme? get _theme =>
      AppTheme.values.byName.nullable(_settingsDao.themeMode.value);

  @override
  SettingsData currentData() => SettingsData(
        themeType: _theme ?? AppTheme.system,
      );

  @override
  Future<void> setTheme(AppTheme value) =>
      _settingsDao.themeMode.setValue(value.name);
}
