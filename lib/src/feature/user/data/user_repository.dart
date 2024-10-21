import 'package:companion/src/feature/auth/extension/secure_storage.dart';
import 'package:companion/src/feature/user/database/dao/users_dao.dart';
import 'package:companion/src/feature/user/extension/user_extension.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserException implements Exception {
  UserException({this.message = 'UserException error'});

  final String? message;

  @override
  String toString() => 'UserException: $message';
}

abstract class IUserRepository {
  Stream<User?> get user;

  Future<User> fetchUser({String? userId});

  Future<void> editUser(User user);
}

class UserRepository implements IUserRepository {
  UserRepository({
    required UsersDao usersDao,
    required CompanionClient client,
    required FlutterSecureStorage secureStorage,
  })  : _usersDao = usersDao,
        _secureStorage = secureStorage,
        _client = client;

  final FlutterSecureStorage _secureStorage;

  final CompanionClient _client;

  final UsersDao _usersDao;

  @override
  Future<User> fetchUser({String? userId}) async {
    try {
      var userQueryId = userId;
      var idFromDb = false;
      if (userQueryId == null) {
        final dbUserId = await _secureStorage.userId;
        if (dbUserId != null) {
          userQueryId = dbUserId;
          idFromDb = true;
        } else {
          Error.throwWithStackTrace(
            UserException(message: 'Необходимо авторизоваться'),
            StackTrace.current,
          );
        }
      }
      final user = await _client.getUser(usersId: userQueryId);
      if (idFromDb) {
        _usersDao.upsertUser(user.toDBUser());
      }
      return user.toUser();
    } on UserException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UserException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        Error.throwWithStackTrace(
          UserException(message: 'Аккаунт был удален'),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(
        UserException(),
        StackTrace.current,
      );
    }
  }

  @override
  Future<void> editUser(User user) async {
    try {
      final response = await _client.updateUser(
        userForEdit: user.toUserForEditResponse(),
      );
      if (response.response.statusCode == 200) {
        await fetchUser();
      } else if (response.data.containsKey('status')) {
        final status = response.data['status'] as bool?;
        if (status ?? false) {
          Error.throwWithStackTrace(
            UserException(message: response.data['message'].toString()),
            StackTrace.current,
          );
        }
      } else {
        Error.throwWithStackTrace(
          UserException(message: 'Ошибка, повторите попытку попозже'),
          StackTrace.current,
        );
      }
    } on UserException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UserException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        await logOut();
        Error.throwWithStackTrace(
          UserException(message: 'Аккаунт был удален'),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(
        UserException(),
        stackTrace,
      );
    }
  }

  Future<void> logOut() async {
    await _secureStorage.clearUserId();
    _usersDao.deleteAllUsers();
  }

  @override
  Stream<User?> get user =>
      _usersDao.dbUsers.map((userDB) => userDB.toUser()).watchSingleOrNull();
}
