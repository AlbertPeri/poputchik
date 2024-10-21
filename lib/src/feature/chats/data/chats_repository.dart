// ignore_for_file: one_member_abstracts

import 'package:companion/src/feature/auth/extension/secure_storage.dart';
import 'package:companion/src/feature/chats/extension/chats_extension.dart';
import 'package:companion/src/feature/chats/models/chats_list/chats_list.dart';
import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion_api/companion.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatsException implements Exception {
  ChatsException({this.message = 'ChatsException error'});

  final String? message;

  @override
  String toString() => 'ChatsException: $message';
}

abstract class IChatsRepository {
  Future<ChatsList> getChats({String? userId});

  Future<void> deleteChat({
    required int chatId,
    required int? userId,
  });
}

class ChatsRepository implements IChatsRepository {
  ChatsRepository({
    required CompanionClient client,
    required FlutterSecureStorage secureStorage,
  })  : _client = client,
        _secureStorage = secureStorage;

  final CompanionClient _client;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<ChatsList> getChats({String? userId}) async {
    try {
      final id = userId ?? (await _secureStorage.userId);
      if (id != null) {
        final chatsResponse = await _client.getChats(usersId: id);
        return chatsResponse.data.toChatsList();
      } else {
        Error.throwWithStackTrace(
          UserException(message: 'Необходимо авторизоваться'),
          StackTrace.current,
        );
      }
    } on ChatsException catch (error) {
      throw ChatsException(message: error.message);
    }
  }

  @override
  Future<void> deleteChat({
    required int chatId,
    required int? userId,
  }) async {
    try {
      final id = userId ?? (await _secureStorage.userId);
      if (id != null) {
        final response = await _client.deleteChat(
          chatId: chatId,
          deletedById: int.parse(id.toString()),
        );
        if (response.response.statusCode == 200) {
          return;
        } else {
          Error.throwWithStackTrace(
            UserException(message: 'Нужно авторизоваться'),
            StackTrace.current,
          );
        }
      }
    } on ChatsException catch (error) {
      Error.throwWithStackTrace(
        ChatsException(message: error.message),
        StackTrace.current,
      );
    }
  }
}
