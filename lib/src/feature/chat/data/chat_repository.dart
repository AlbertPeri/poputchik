// ignore_for_file: avoid_dynamic_calls

import 'package:companion/src/config/app_config.dart';
import 'package:companion/src/feature/chat/extension/chat_extension.dart';
import 'package:companion/src/feature/chat/models/messages_info/messages_info.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:l/l.dart';

class ChatException implements Exception {
  ChatException({this.message = 'ChatException error'});

  final String? message;

  @override
  String toString() => 'ChatException: $message';
}

abstract class IChatRepository {
  Future<void> sendMessage({
    required String userId,
    required String chatId,
    required String content,
  });

  Future<int> createChat({
    required String creatorId,
    required String targetId,
    required int readerId,
    String? content,
  });

  Future<MessagesInfo> getMessages({
    required String? chatId,
    required int readerId,
    int? page,
    int? latestMessageId,
  });

  Future<void> unBlockUser({
    required String senderId,
    required String targetId,
  });

  Future<void> blockUser({
    required String senderId,
    required String targetId,
  });
}

class ChatRepository implements IChatRepository {
  ChatRepository({
    required CompanionClient client,
  }) : _client = client;

  final CompanionClient _client;

  @override
  Future<int> createChat({
    required String creatorId,
    required String targetId,
    required int readerId,
    String? content,
  }) async {
    try {
      final response = await _client.createChat(
        creatorId: creatorId,
        targetId: targetId,
        content: content,
        readerId: readerId,
      );

      final id = response.chat?.id;
      final isSuccess = response.success && id != null;
      if (isSuccess) {
        return id;
      } else {
        Error.throwWithStackTrace(
          ChatException(message: 'Не удалось создать чат'),
          StackTrace.current,
        );
      }
    } on ChatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(message: error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(message: 'Ошибка при загрузке данных'),
        stackTrace,
      );
    }
  }

  @override
  Future<void> sendMessage({
    required String userId,
    required String chatId,
    required String content,
  }) async {
    try {
      await _client.sendMessage(
        userId: userId,
        chatId: chatId,
        content: content,
      );
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(
          message: error.response?.data['message'].toString() ?? 'Ошибка сети',
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<MessagesInfo> getMessages({
    required String? chatId,
    required int readerId,
    int? page,
    int? latestMessageId,
  }) async {
    try {
      final response = await _client.getMessages(
        chatId: chatId,
        page: page,
        readerId: readerId,
      );
      if (response.response.statusCode == 200) {
        return response.data.toMessagesInfo();
      } else {
        Error.throwWithStackTrace(
          ChatException(message: 'Ошибка, повторите попытку попозже'),
          StackTrace.current,
        );
      }
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(
          message: error.response?.data['message'].toString() ?? 'Ошибка сети',
        ),
        stackTrace,
      );
    }
  }

  static Map<String, Object?>? parseChatData(Map<String, Object?>? payload) {
    l.s(payload ?? '');
    final containsData = payload?.containsKey('data') ?? false;

    final containsChatId = payload?.containsKey('chat_id') ?? false;
    if (payload != null && containsChatId || payload != null && containsData) {
      Map<String, Object?>? data = payload;
      if (containsData) {
        data = Map<String, Object?>.from(payload['data']! as Map);
      }
      if (data.containsKey('chat_id')) {
        return {
          'chatId': data['chat_id'],
          'targetName': data['senderName'],
          'targetId': data['senderId'],
          'targetAvatar': data.containsKey('senderImage')
              ? AppConfig.baseUrl + (data['senderImage']! as String)
              : null,
        };
      }
    }
    return null;
  }

  @override
  Future<void> unBlockUser({
    required String senderId,
    required String targetId,
  }) async {
    try {
      final response = await _client.unBlockUser(
        senderId: senderId,
        targetId: targetId,
      );

      final isSuccess = response.response.statusCode == 200;
      if (isSuccess) {
        return;
      } else {
        Error.throwWithStackTrace(
          ChatException(message: 'Не удалось разблокировать пользователя'),
          StackTrace.current,
        );
      }
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(
          message: error.response?.data['message'].toString() ?? 'Ошибка сети',
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> blockUser({
    required String senderId,
    required String targetId,
  }) async {
    try {
      final response = await _client.blockUser(
        senderId: senderId,
        targetId: targetId,
      );

      final isSuccess = response.response.statusCode == 200;
      if (isSuccess) {
        return;
      } else {
        Error.throwWithStackTrace(
          ChatException(message: 'Не удалось заблокировать пользователя'),
          StackTrace.current,
        );
      }
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ChatException(
          message: error.response?.data['message'].toString() ?? 'Ошибка сети',
        ),
        stackTrace,
      );
    }
  }
}
