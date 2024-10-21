import 'package:freezed_annotation/freezed_annotation.dart';

/// Исключение содержащее исходный StackTrace
@immutable
abstract class Throwable implements Exception {
  Throwable([StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;

  /// Исходный стектрейс
  final StackTrace stackTrace;
}

/// Не важные, предсказуемые исключения
/// Например "такого элемента не существует" или "отсутсвует интернет"
abstract class MinorException implements Throwable {}

/// Исключение приложения
@immutable
abstract class AppException implements Throwable {
  const AppException(
    this.stackTrace, [
    this.message,
  ]);

  /// Исходный стектрейс
  @override
  final StackTrace stackTrace;

  /// Сообщение об ошибки или исходная ошибка строкой
  final String? message;

  @override
  String toString() {
    if (message == null) return 'AppException';
    return 'AppException: $message';
  }
}

/// Не авторизован
class NotAuthorized extends AppException implements MinorException {
  const NotAuthorized(
    super.stackTrace, [
    super.message,
  ]);

  @override
  String toString() {
    if (message == null) return 'NotAuthorized';
    return 'NotAuthorized: $message';
  }
}
