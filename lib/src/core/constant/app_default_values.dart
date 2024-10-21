import 'dart:io' show Platform;

/// Дефолтные значения
class AppDefaulValues {
  /// Таймаут соединения с серверером
  static const connectionTimeout = Duration(seconds: 15);

  /// Текущая платформа в строковом формате: `ios` `android`
  static final platform = Platform.isIOS ? 'ios' : 'android';

  /// Дефолтные значение для длительности анимации
  static const animationDuration = Duration(milliseconds: 250);
}
