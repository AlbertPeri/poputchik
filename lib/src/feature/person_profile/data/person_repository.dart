// ignore_for_file: avoid_dynamic_calls

import 'package:companion/src/feature/user/extension/user_extension.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';

class PersonException implements Exception {
  PersonException({this.message = 'PersonException error'});

  final String? message;

  @override
  String toString() => '$message';
}

abstract class IPersonRepository {
  Future<User> getPerson({
    required String userId,
  });

  Future<void> postReview({
    required String senderId,
    required String receiverId,
    required String content,
    required int rating,
  });
}

class PersonRepository implements IPersonRepository {
  PersonRepository({
    required CompanionClient client,
  }) : _client = client;

  final CompanionClient _client;

  @override
  Future<User> getPerson({required String userId}) async {
    try {
      final user = await _client.getUser(usersId: userId);
      return user.toUser();
    } on PersonException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        PersonException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        Error.throwWithStackTrace(
          PersonException(message: 'Аккаунт был удален'),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(
        PersonException(),
        StackTrace.current,
      );
    }
  }

  @override
  Future<void> postReview({
    required String senderId,
    required String receiverId,
    required String content,
    required int rating,
  }) async {
    try {
      await _client
          .postReview(
        senderId: senderId,
        receiverId: receiverId,
        rating: rating,
        content: content,
      )
          .catchError((error) {
        Error.throwWithStackTrace(
          PersonException(message: 'Что-то пошло не так. Попробуйте еще раз'),
          StackTrace.current,
        );
      });
    } on PersonException catch (error) {
      Error.throwWithStackTrace(
        PersonException(message: error.message),
        StackTrace.current,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 500) {
        Error.throwWithStackTrace(
          PersonException(message: 'Такого пользователя не существует'),
          stackTrace,
        );
      }
      if (error.response?.statusCode == 404) {
        Error.throwWithStackTrace(
          PersonException(
            message: error.response?.data['message'].toString() ?? 'Ууупс',
          ),
          stackTrace,
        );
      } else {
        Error.throwWithStackTrace(
          PersonException(message: 'Что-то пошло не так. Попробуйте еще раз'),
          stackTrace,
        );
      }
    }
  }
}
