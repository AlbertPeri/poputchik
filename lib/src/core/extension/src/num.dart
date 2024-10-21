import 'package:intl/intl.dart';

extension NumX on num {
  /// Переводит в рубли
  String get rubles =>
      NumberFormat.currency(locale: 'ru', symbol: '\u{20BD}', decimalDigits: 0)
          .format(this);
}
