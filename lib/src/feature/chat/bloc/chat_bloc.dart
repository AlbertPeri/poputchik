import 'package:companion/src/feature/chat/data/chat_repository.dart';
import 'package:companion/src/feature/chat/models/message/message.dart';
import 'package:companion/src/feature/chat/models/messages_info/messages_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required IChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(const ChatState.initial()) {
    on<_SendMessage>(_onSendMessage);
    on<_CreateChat>(_onCreateChat);
    on<_GetMessages>(_onGetMessages);
    on<_UnBlockUser>(_onUnBlockUser);
    on<_BlockUser>(_onBlockUser);
  }

  final IChatRepository _chatRepository;
  int _page = 0;

  Future<void> _onSendMessage(
    _SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final list = state.messagesInfo?.info.data ?? [];
      final time = DateTime.now().toIso8601String();
      final newMessage = Message(
        content: event.content.trim(),
        updatedAt: time,
        userId: int.parse(event.userId),
        createdAt: time,
        chatId: int.parse(event.chatId),
        id: DateTime.now().millisecondsSinceEpoch,
      );
      final currentInfo = state.messagesInfo;
      emit(
        state.copyWith(
          messagesInfo: currentInfo != null
              ? currentInfo.copyWith(
                  info: currentInfo.info.copyWith(data: [newMessage, ...list]),
                )
              : null,
        ),
      );
      if (!event.isRecievedMessage) {
        await _chatRepository.sendMessage(
          content: event.content.trim(),
          userId: event.userId,
          chatId: event.chatId,
        );
      }
    } on ChatException catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.message,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateChat(
    _CreateChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatState.updating(messagesInfo: state.messagesInfo));
    try {
      final id = await _chatRepository.createChat(
        content: event.content,
        creatorId: event.creatorId,
        targetId: event.targetId,
        readerId: event.readerId,
      );
      emit(
        ChatState.created(
          messagesInfo: state.messagesInfo,
          chatId: id,
        ),
      );
      add(
        ChatEvent.getMessages(
          chatId: id.toString(),
          readerId: event.readerId,
        ),
      );
    } on ChatException catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.message,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.toString(),
        ),
      );
    } finally {
      emit(ChatState.loaded(messagesInfo: state.messagesInfo));
    }
  }

  Future<void> _onGetMessages(
    _GetMessages event,
    Emitter<ChatState> emit,
  ) async {
    final currentMessagesInfo = state.messagesInfo;
    final info = currentMessagesInfo?.info;
    final lastPage = info?.lastPage ?? 1;

    if (_page >= lastPage) {
      return;
    }
    _page++;

    if (!event.forceRefresh) {
      emit(ChatState.updating(messagesInfo: currentMessagesInfo));
    }
    final currentMessages = info?.data ?? [];

    try {
      final messagesInfo = await _chatRepository.getMessages(
        chatId: event.chatId,
        page: _page,
        latestMessageId: event.latestMessageId,
        readerId: event.readerId,
      );

      final newInfo = messagesInfo.info;
      final messages = newInfo.data;

      final newMessagesInfo = messagesInfo.copyWith(
        info: newInfo.copyWith(
          data: [...currentMessages, ...messages].where((element) {
            final content = element.content;
            return content != null && content.isNotEmpty;
          }).toList(),
        ),
      );

      emit(ChatState.loaded(messagesInfo: newMessagesInfo));
    } on ChatException catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.message,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onUnBlockUser(
    _UnBlockUser event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.unBlockUser(
        senderId: event.senderId,
        targetId: event.targetId,
      );
    } on ChatException catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.message,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.toString(),
        ),
      );
    } finally {
      emit(ChatState.loaded(messagesInfo: state.messagesInfo));
    }
  }

  Future<void> _onBlockUser(
    _BlockUser event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.blockUser(
        senderId: event.senderId,
        targetId: event.targetId,
      );
    } on ChatException catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.message,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatState.error(
          messagesInfo: state.messagesInfo,
          error: error.toString(),
        ),
      );
    } finally {
      emit(ChatState.loaded(messagesInfo: state.messagesInfo));
    }
  }
}
