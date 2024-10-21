// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/extension/secure_storage.dart';
import 'package:companion/src/feature/user/database/dao/users_dao.dart';
import 'package:companion/src/feature/user/extension/user_extension.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:l/l.dart';

class AuthException implements Exception {
  AuthException({this.message = 'Authorization error'});

  final String? message;

  @override
  String toString() => 'AuthException: $message';
}

abstract class IAuthRepository {
  Stream<User?> get user;

  Future<String> sendPhone({
    required String phone,
  });

  Future<User> checkAuthCode({
    required String phoneNumber,
    required String verificationCode,
  });

  Future<void> logOut({required int? userId});
}

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required UsersDao usersDao,
    required CompanionClient client,
    required FlutterSecureStorage secureStorage,
  })  : _usersDao = usersDao,
        _secureStorage = secureStorage,
        _client = client;

  final CompanionClient _client;

  final FlutterSecureStorage _secureStorage;

  final UsersDao _usersDao;

  @override
  Future<User> checkAuthCode({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    try {
      final authResponse = await _client.checkCode(
        phoneNumber: phoneNumber.onlyDigits,
        verificationCode: verificationCode,
      );
      final data = authResponse.response.data as Map<String, dynamic>;
      if (data.containsKey('status')) {
        if (data['status'] == false) {
          Error.throwWithStackTrace(
            AuthException(message: data['message'].toString()),
            StackTrace.current,
          );
        } else {
          Error.throwWithStackTrace(
            AuthException(),
            StackTrace.current,
          );
        }
      } else {
        final usersId = data['id'].toString();
        _secureStorage.setUserId(usersId);
        final userResponse = await _client.getUser(usersId: usersId);

        final dbUser = userResponse
            .copyWith(phoneNumber: phoneNumber.onlyDigits)
            .toDBUser();
        _usersDao.upsertUser(
          dbUser,
        );

        return userResponse.toUser();
      }
    } on AuthException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response!.statusCode == 401) {
        Error.throwWithStackTrace(
          AuthException(message: 'Неверный код'),
          stackTrace,
        );
      } else {
        Error.throwWithStackTrace(
          AuthException(message: 'Что-то пошло не так. Попробуйте еще раз'),
          stackTrace,
        );
      }
    }
  }

  @override
  Future<String> sendPhone({required String phone}) async {
    try {
      final phoneMask = phone.replaceAll(RegExp('[^0-9]'), '');
      final statusResponse = await _client.sendPhone(phone: phoneMask);
      final notSent = statusResponse.response.data['success'] as bool;
      // final userId =
      //     statusResponse.response.data['data']['user']['id'].toString();
      if (!notSent) {
        Error.throwWithStackTrace(
          AuthException(
            message: 'Что-то пошло не так. Попробуйте еще раз',
          ),
          StackTrace.current,
        );
      } else {
        return phoneMask;
      }
    } on AuthException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException(),
        stackTrace,
      );
    }
  }

  @override
  Future<void> logOut({required int? userId}) async {
    if (userId != null) {
      final res = await _client.logOut(usersId: userId);
      if (res.response.statusCode == 200) {
        l.s('User $userId logged out || ${res.response.data}');
      } else {
        Error.throwWithStackTrace(
          AuthException(message: 'Не удалось очистить токен fmc'),
          StackTrace.current,
        );
      }
    } else {
      Error.throwWithStackTrace(
        AuthException(message: 'UserId is null'),
        StackTrace.current,
      );
    }
    await _secureStorage.clearUserId();
    _usersDao.deleteAllUsers();
  }

  @override
  Stream<User?> get user =>
      _usersDao.dbUsers.watchSingleOrNull().map((userDb) => userDb?.toUser());
}
