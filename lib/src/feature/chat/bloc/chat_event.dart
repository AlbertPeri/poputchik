part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.sendMessage({
    required String userId,
    required String chatId,
    required String content,
    @Default(false) bool isRecievedMessage,
  }) = _SendMessage;

  const factory ChatEvent.createChat({
    required String creatorId,
    required String targetId,
    required int readerId,
    String? content,
  }) = _CreateChat;

  const factory ChatEvent.getMessages({
    required String? chatId,
    required int readerId,
    @Default(false) bool forceRefresh,
    int? latestMessageId,
  }) = _GetMessages;

  const factory ChatEvent.unBlockUser({
    required String senderId,
    required String targetId,
  }) = _UnBlockUser;

  const factory ChatEvent.blockUser({
    required String senderId,
    required String targetId,
  }) = _BlockUser;
}
