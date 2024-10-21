// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:companion/src/feature/chats/data/chats_repository.dart';
import 'package:companion/src/feature/chats/models/chats_list/chats_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'chats_bloc.freezed.dart';
part 'chats_event.dart';
part 'chats_state.dart';

const _duration = Duration(milliseconds: 500);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc({
    required IChatsRepository chatsRepository,
  })  : _chatsRepository = chatsRepository,
        super(const ChatsState.initial()) {
    on<_GetChatsList>(_onGetChats, transformer: debounce(_duration));
    on<_DeleteChat>(_onDeleteChat);
  }

  final IChatsRepository _chatsRepository;

  Future<void> _onGetChats(
    _GetChatsList event,
    Emitter<ChatsState> emit,
  ) async {
    if (!event.isUpdated) {
      emit(ChatsState.processing(chatsList: state.chatsList));
    }
    try {
      final chatsList =
          await _chatsRepository.getChats(userId: event.userId.toString());
      final list = chatsList.chatList.toList();
      final readChatId = event.readChatId;
      if (readChatId != null) {
        final index =
            list.indexWhere((element) => element.chatId == readChatId);
        // l.s(state.chatsList?.chatList[index].toString() ?? '');

        final latestMessage = list[index].latestMessage;
        list[index] = list[index].copyWith(
          latestMessage: latestMessage?.copyWith(isSeen: true),
        );
      }

      return emit(
        ChatsState.loaded(chatsList: chatsList.copyWith(chatList: list)),
      );
    } on ChatsException catch (error) {
      emit(
        ChatsState.error(
          error: error.message,
          chatsList: state.chatsList,
        ),
      );
    } on Object catch (error) {
      emit(
        ChatsState.error(
          error: error.toString(),
          chatsList: state.chatsList,
        ),
      );
    }
  }

  Future<void> _onDeleteChat(
    _DeleteChat event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      //emit(ChatsState.processing(chatsList: state.chatsList));

      // Удаление чата из репозитория
      await _chatsRepository.deleteChat(
        chatId: event.chatId,
        userId: event.userId,
      );

      // Удаление чата из локального списка в состоянии
      final updatedChatList = state.chatsList?.chatList
          .where((chat) => chat.chatId != event.chatId)
          .toList();

      // Обновление состояния с новым списком
      if (updatedChatList != null) {
        emit(
          ChatsState.loaded(
            chatsList: state.chatsList?.copyWith(chatList: updatedChatList) ??
                const ChatsList(chatList: []),
          ),
        );
      } else {
        // Если вдруг список оказался пустым или null, можно обработать этот случай, например:
        emit(
          ChatsState.loaded(
            chatsList: state.chatsList?.copyWith(chatList: []) ??
                const ChatsList(chatList: []),
          ),
        );
      }
    } on ChatsException catch (error) {
      print(error);
      emit(
        ChatsState.error(
          error: error.message,
          chatsList: state.chatsList,
        ),
      );
    } on Object catch (error) {
      print(error);
      emit(
        ChatsState.error(
          error: error.toString(),
          chatsList: state.chatsList,
        ),
      );
    }
  }

  // Future<void> _onDeleteChat(
  //   _DeleteChat event,
  //   Emitter<ChatsState> emit,
  // ) async {
  //   try {
  //     emit(ChatsState.processing(chatsList: state.chatsList));
  //     await _chatsRepository.deleteChat(chatId: event.chatId);
  //   } on ChatsException catch (error) {
  //     emit(
  //       ChatsState.error(
  //         error: error.message,
  //         chatsList: state.chatsList,
  //       ),
  //     );
  //   } on Object catch (error) {
  //     emit(
  //       ChatsState.error(
  //         error: error.toString(),
  //         chatsList: state.chatsList,
  //       ),
  //     );
  //   }
  // }
}
