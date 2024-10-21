import 'package:intl/intl.dart';

extension DateX on DateTime {
  /// Перевод даты в строковый формат для отображения в приложении
  String pretty({bool withHours = true}) =>
      DateFormat(withHours ? 'dd.MM.yyyy в HH:mm' : 'dd.MM.yyyy')
          .format(toLocal());

  /// Перевод даты в строковый формат времени
  String get time => DateFormat('HH:mm').format(toLocal());

  /// Перевод даты в строковый формат с названием месяца
  String get withMonthName => DateFormat('dd MMMM yyyy г.').format(toLocal());

  /// являются ли дни равными
  bool equalDay(DateTime date) =>
      day == date.day && month == date.month && year == date.year;
}
