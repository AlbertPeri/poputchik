import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/chats/bloc/chats_bloc.dart';
import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:companion/src/feature/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Chats> _chatsList(ChatsState state) => state.chatsList?.chatList ?? [];

bool _isLoading(ChatsState state) => state.isProcessing;

bool _isIdling(ChatsState state) => state.isIdling;

class ChatsScope extends StatelessWidget {
  const ChatsScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static ValueNotifier<Set<String>> undreadChatsIds = ValueNotifier({});

  static const BlocScope<ChatsEvent, ChatsState, ChatsBloc> _scope =
      BlocScope();

  static ScopeData<List<Chats>> get chatsListOf => _scope.select(_chatsList);

  static ScopeData<bool> get isLoadingOf => _scope.select(_isLoading);

  static ScopeData<bool> get isIdlingOf => _scope.select(_isIdling);

  static UnaryScopeMethod<int?> get getChatsList => _scope.unary(
        (context, userId) => ChatsEvent.getChatsList(userId: userId),
      );

  static void updateChatList(
    BuildContext context,
    int? userId, {
    int? readChatId,
  }) {
    if (userId != null) {
      context.read<ChatsBloc>().add(
            ChatsEvent.getChatsList(
              userId: userId,
              isUpdated: true,
              readChatId: readChatId,
            ),
          );
    }
  }

  static void deleteChat(
    BuildContext context,
    int chatId,
    int? userId,
  ) {
    context.read<ChatsBloc>().add(
          ChatsEvent.deleteChat(
            chatId: chatId,
            userId: userId,
          ),
        );
  }

  static void addUnreadChatId(RemoteMessage message) =>
      NotificationService.showFlutterNotification(message);

  @override
  Widget build(BuildContext context) => BlocProvider<ChatsBloc>(
        lazy: false,
        create: (context) => ChatsBloc(
          chatsRepository: context.repository.chatsRepository,
        ),
        child: child,
      );
}
