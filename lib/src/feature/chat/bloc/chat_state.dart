part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const ChatState._();
  const factory ChatState.initial({
    MessagesInfo? messagesInfo,
  }) = _ChatInitialState;

  const factory ChatState.updating({
    MessagesInfo? messagesInfo,
  }) = _ChatUpdatingState;

  const factory ChatState.loaded({
    MessagesInfo? messagesInfo,
  }) = _ChatLoadedlState;

  const factory ChatState.created({
    required int chatId,
    MessagesInfo? messagesInfo,
  }) = _CreatedChatState;

  const factory ChatState.error({
    MessagesInfo? messagesInfo,
    String? error,
  }) = _ChatErrorState;

  // If an error has occurred
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isIdling => !isProcessing;

  bool get isLoaded => maybeMap<bool>(orElse: () => false, loaded: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, updating: (_) => true);
}
