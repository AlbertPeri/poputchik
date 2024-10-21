import 'package:dio/dio.dart';

extension DioX on DioException {
  Never throwCustom<T extends Exception>(
    StackTrace stackTrace, {
    required T unknowError,
    required T Function(String message) errorBuilder,
  }) {
    final data = response?.data;
    if (data is Map?) {
      if (data != null) {
        final map = Map<String, dynamic>.from(data);

        if (map.containsKey('message') && map['message'] != null) {
          final message = map['message'] as String?;
          return Error.throwWithStackTrace(
            errorBuilder.call(message!),
            stackTrace,
          );
        } else {
          return Error.throwWithStackTrace(
            unknowError,
            stackTrace,
          );
        }
      } else {
        return Error.throwWithStackTrace(
          unknowError,
          stackTrace,
        );
      }
    } else {
      return Error.throwWithStackTrace(
        unknowError,
        stackTrace,
      );
    }
  }
}
