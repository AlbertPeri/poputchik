part of 'chats_bloc.dart';

@freezed
class ChatsEvent with _$ChatsEvent {
  const factory ChatsEvent.getChatsList({
    int? userId,
    @Default(false) bool isUpdated,
    int? readChatId,
  }) = _GetChatsList;

  const factory ChatsEvent.deleteChat({
    required int chatId,
    required int? userId,
  }) = _DeleteChat;
}
