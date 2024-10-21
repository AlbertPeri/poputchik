import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/chat/bloc/chat_bloc.dart';
import 'package:companion/src/feature/chat/data/chat_repository.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// MessagesInfo _messagesInfo(ChatState state) => state.messagesInfo!;

bool _isLoading(ChatState state) => state.isProcessing;

bool _isIdling(ChatState state) => state.isIdling;

class ChatScope extends StatelessWidget {
  const ChatScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const BlocScope<ChatEvent, ChatState, ChatBloc> _scope = BlocScope();

  // static ScopeData<ChatsList> get chatsListOf => _scope.select(_chatsList);

  static ScopeData<bool> get isLoadingOf => _scope.select(_isLoading);

  static ScopeData<bool> get isIdlingOf => _scope.select(_isIdling);

  // static NullaryScopeMethod get sendMessage => _scope.nullary(
  //       (context, ) => const ChatEvent.sendMessage(),
  //     );
  static void openChat(
    BuildContext context,
    Map<String, Object?>? payload,
  ) {
    final data = ChatRepository.parseChatData(payload);
    if (data != null) {
      if (context.mounted) {
        final location = Uri.parse(GoRouter.of(context).location);
        if (location.pathSegments.last == (RouteNames.chat)) {
          context.pushNamed(
            RouteNames.chat,
            queryParameters: data,
          );
        } else {
          context.goNamed(
            RouteNames.chat,
            queryParameters: data,
          );
        }
      }
    }
  }

  static Future<void> sendMessage(
    BuildContext context, {
    required String chatId,
    required String content,
    String? userId,
    bool isRecievedMessage = false,
  }) async {
    final currentUserId = userId ?? UserScope.userOf(context).id.toString();
    context.read<ChatBloc>().add(
          ChatEvent.sendMessage(
            userId: currentUserId,
            chatId: chatId,
            content: content,
            isRecievedMessage: isRecievedMessage,
          ),
        );
  }

  static Future<void> unBlockUser(
    BuildContext context, {
    required String senderId,
    required String targetId,
  }) async {
    context.read<ChatBloc>().add(
          ChatEvent.unBlockUser(
            senderId: senderId,
            targetId: targetId,
          ),
        );
  }

  static Future<void> blockUser(
    BuildContext context, {
    required String senderId,
    required String targetId,
  }) async {
    context.read<ChatBloc>().add(
          ChatEvent.blockUser(
            senderId: senderId,
            targetId: targetId,
          ),
        );
  }

  static void getMessages(
    BuildContext context, {
    required String? chatId,
    required int readerId,
    bool refresh = false,
  }) {
    context.read<ChatBloc>().add(
          ChatEvent.getMessages(
            chatId: chatId,
            forceRefresh: refresh,
            readerId: readerId,
          ),
        );
  }

  static Future<void> createChat(
    BuildContext context, {
    required String targetId,
    required int readerId,
    String? content,
  }) async {
    final userId = UserScope.userOf(context).id.toString();
    context.read<ChatBloc>().add(
          ChatEvent.createChat(
            creatorId: userId,
            targetId: targetId,
            content: content,
            readerId: readerId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          chatRepository: context.repository.chatRepository,
        ),
        child: child,
      );
}
