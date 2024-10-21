import 'package:companion/src/feature/settings/enum/theme_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_data.freezed.dart';

@freezed
class SettingsData with _$SettingsData {
  const factory SettingsData({
    required AppTheme themeType,
  }) = _SettingsData;
}
