part of 'chats_bloc.dart';

@freezed
class ChatsState with _$ChatsState {
  const ChatsState._();
  const factory ChatsState.initial({
    ChatsList? chatsList,
  }) = _ChatsInitialState;

  const factory ChatsState.processing({
    ChatsList? chatsList,
  }) = _ChatsUpdatingState;

  const factory ChatsState.loaded({
    required ChatsList chatsList,
  }) = _ChatsLoadedlState;

  const factory ChatsState.error({
    ChatsList? chatsList,
    String? error,
  }) = _ChatsErrorState;

  // If an error has occurred
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isIdling => !isProcessing;

  bool get isLoaded => maybeMap<bool>(orElse: () => false, loaded: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);
}
