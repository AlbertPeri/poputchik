import 'package:intl/intl.dart';

extension StringX on String {
  /// Только цифры
  String get onlyDigits => replaceAll(RegExp('[^0-9]'), '');

  /// Форматирование строки с первой заглавной
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Форматирует в дату
  DateTime toDate({bool clearHours = false}) {
    final date = DateFormat(
      'dd.MM.yyyy',
    ).parse(this);

    return clearHours ? DateTime(date.year, date.month, date.day) : date;
  }

  DateTime parseDateTime() {
    return DateTime.parse(this).toLocal();
  }
}
