import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';
import 'package:companion/gen/assets.gen.dart';
import 'package:companion/gen/fonts.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/chat/bloc/chat_bloc.dart';
import 'package:companion/src/feature/chat/data/chat_repository.dart';
import 'package:companion/src/feature/chat/models/messages_info/messages_info.dart';
import 'package:companion/src/feature/chat/scope/chat_scope.dart';
import 'package:companion/src/feature/chat/widget/chat_app_bar/chat_app_bar.dart';
import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/notification/notification_service.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l/l.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.info,
    super.key,
    this.targetId,
    this.targetName,
    this.targetAvatar,
    this.phone,
    this.chatId,
    this.latesMessageId,
  });

  final Chats? info;

  final int? targetId;

  final String? targetName;

  final String? targetAvatar;

  final String? phone;

  final String? chatId;

  final int? latesMessageId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String? id = widget.chatId ?? widget.info?.chatId.toString();

  late Chats info = widget.info ?? const Chats.empty();

  late final TextEditingController _textController;

  final AutoScrollController _scrollController = AutoScrollController();

  StreamSubscription<RemoteMessage?>? _streamSubscription;

  List<types.Message> messages = [];

  late bool isNotUserBlocked;

  late int? senderBlockId;

  @override
  void initState() {
    super.initState();
    NotificationService.cancelAllNotifications();
    isNotUserBlocked = info.senderBlockId == null;
    senderBlockId = info.senderBlockId;

    final targetId = widget.targetId;
    if (targetId != null || id == null) {
      ChatScope.createChat(
        context,
        readerId: userId,
        targetId: targetId.toString(),
      );
    } else {
      ChatScope.getMessages(
        context,
        chatId: id,
        readerId: userId,
      );
    }

    ChatsScope.getChatsList(context, userId);

    _textController = TextEditingController();

    _streamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (id != null) {
        ChatsScope.updateChatList(context, userId, readChatId: int.parse(id!));
      }
      final data = ChatRepository.parseChatData(message.data);
      final body = message.notification?.body;

      if (data != null &&
          data['chatId'] == id &&
          context.mounted &&
          id != null &&
          body != null) {
        ChatScope.sendMessage(
          context,
          chatId: id!,
          userId: companionId,
          content: body,
          isRecievedMessage: true,
        );
      }
    });
  }

  Future<void> _handleEndReached() async {
    final bloc = context.read<ChatBloc>();
    final s = bloc.stream;
    if (context.mounted) {
      ChatScope.getMessages(
        context,
        chatId: id,
        refresh: true,
        readerId: userId,
      );
    }

    await for (final state in s) {
      final isSuccess = state.isProcessing && state.isIdling;
      if (isSuccess) break;
    }
  }

  @override
  void deactivate() {
    l
      ..s('targetId: $companionId')
      ..s('chatId: $id')
      ..s('userId: $userId');
    super.deactivate();
  }

  @override
  void dispose() {
    _textController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _showUnBlockDialog(
    BuildContext context,
    String targetId,
  ) =>
      AppDialog.showCustomDialog(
        context,
        title: 'Разблокировать пользователя?',
        actionTitle: 'Да',
        onActionTap: () {
          setState(() {
            ChatScope.unBlockUser(
              context,
              senderId: UserScope.userOf(context).id.toString(),
              targetId: targetId,
            );
            isNotUserBlocked = true;
            ChatsScope.getChatsList(context, userId);
          });
          context.pop();
        },
      );

  int get userId => UserScope.userOf(context).id;

  bool get creatorIsUser => info.creatorId == userId;

  String? get companionId =>
      widget.targetId?.toString() ??
      (creatorIsUser ? info.targetId.toString() : info.creatorId.toString());

  String get companionName =>
      widget.targetName ?? (creatorIsUser ? info.targetName : info.creatorName);

  String? get companionImageUrl =>
      widget.targetAvatar ??
      (creatorIsUser ? info.targetMainImage : info.creatorMainImage);

  types.User toUser({String? id}) {
    return types.User(
      id: id ?? companionId ?? userId.toString(),
      firstName: companionName,
      imageUrl: companionImageUrl,
    );
  }

  static const textStyle = TextStyle(
    color: Colors.black,
    fontFamily: FontFamily.nunito,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  DefaultChatTheme get defaultChatTheme => DefaultChatTheme(
        sentMessageBodyTextStyle: textStyle,
        receivedMessageBodyTextStyle: textStyle,
        secondaryColor: Colors.white,
        primaryColor: Colors.transparent,
        inputSurfaceTintColor: Colors.black,
        backgroundColor: context.theme.scaffoldBackgroundColor,
      );

  @override
  Widget build(BuildContext context) {
    final chatsList = ChatsScope.chatsListOf(context, listen: true);
    _updateChatData(chatsList);

    return Material(
      child: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
            previous.messagesInfo != current.messagesInfo ||
            (current.messagesInfo?.info.data.isEmpty ?? true),
        listener: (context, state) {
          state.whenOrNull(
            error: (messagesInfo, error) => context.toastService
                .showError(error ?? context.localized.errorSomethingsWrong),
            created: (chatId, messagesInfo) => setState(() {
              id = chatId.toString();
            }),
            loaded: (messagesInfo) {
              final isEmpty = messagesInfo?.info.data.isEmpty ?? false;
              if (isEmpty) {
                _textController.text = 'Здравствуйте!';
              }
            },
          );
        },
        builder: (context, state) {
          final agent = toUser();
          const emptyPlaceholder = EmptyPlaceholder(
            message: 'Сообщений пока нет',
          );
          final messagesInfo = state.messagesInfo;
          return Scaffold(
            appBar: ChatAppBar(
              avatarUrl: agent.imageUrl,
              personName: agent.firstName ?? 'Аноним',
              personId: agent.id,
              chatId: id,
              isNotUserBlocked: isNotUserBlocked,
              onBlockStatusChanged: (bool isNotBlocked) {
                // Обновление переменной
                setState(() => isNotUserBlocked = isNotBlocked);
              },
            ),
            body: state.maybeWhen(
              error: (messagesInfo, error) {
                return EmptyPlaceholder(
                  message: error ?? context.localized.errorSomethingsWrong,
                );
              },
              updating: (_) => const Loader(),
              orElse: () {
                if (messagesInfo == null) return emptyPlaceholder;
                messages = _parseMessages(messagesInfo);
                final isLastPage = messagesInfo.info.isLastPage;

                return Chat(
                  isLastPage: isLastPage,
                  emptyState: emptyPlaceholder,
                  onEndReached: _handleEndReached,
                  onSendPressed: (text) {},
                  scrollController: _scrollController,
                  l10n: const ChatL10nRu(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  useTopSafeAreaInset: true,
                  dateHeaderThreshold: 86400000,
                  dateHeaderBuilder: (dateHeader) => DateBuilder(
                    dateTime: dateHeader.dateTime,
                  ),
                  theme: defaultChatTheme,
                  messages: messages,
                  bubbleBuilder: _bubbleBuilder,
                  user: toUser(id: userId.toString()),
                  customBottomWidget: isNotUserBlocked
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: SafeArea(
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: TextField(
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      controller: _textController,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 3,
                                      style: AppTypography.nunito14Regular,
                                      decoration: InputDecoration(
                                        hintText: 'Введите сообщение',
                                        hintStyle: AppTypography.nunito14Regular
                                            .copyWith(
                                          color: AppColors.grey3,
                                        ),
                                        filled: true,
                                        isCollapsed: true,
                                        fillColor: AppColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(18),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _onSendMessageTap(context);
                                  },
                                  icon: Assets.icons.icSendArrow.svg(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : senderBlockId == userId || senderBlockId == null
                          ? SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: AppButton(
                                  text: 'Разблокировать',
                                  height: 60,
                                  width: double.infinity,
                                  borderRadius: 20,
                                  onPressed: () async {
                                    _showUnBlockDialog(context, agent.id);
                                  },
                                ),
                              ),
                            )
                          : const SafeArea(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  height: 60,
                                  child: Text(
                                    'Пользователь вас заблокировал',
                                    style: AppTypography.nunitoSans16Bold,
                                  ),
                                ),
                              ),
                            ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _updateChatData(List<Chats> chatsList) {
    final chat = chatsList.firstWhereOrNull((c) => c.chatId == info.chatId);
    final newSenderBlockId = chat?.senderBlockId;
    print('NEW SENDER BLOCK ID - $newSenderBlockId');
    if (chat != null && newSenderBlockId != senderBlockId) {
      setState(() {
        senderBlockId = newSenderBlockId;
        isNotUserBlocked = senderBlockId == null;
      });
    }
  }

  List<types.TextMessage> _parseMessages(MessagesInfo messagesInfo) {
    return messagesInfo.info.data
        .where(
      (element) => element.content != null && element.content!.isNotEmpty,
    )
        .map(
      (message) {
        return types.TextMessage(
          text: message.content ?? '',
          id: message.id.toString(),
          createdAt: message.createdAt.parseDateTime().millisecondsSinceEpoch,
          author: toUser(id: message.userId.toString()),
          type: types.MessageType.text,
        );
      },
    ).toList();
  }

  Widget _bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final createdAt = message.createdAt;
    final isUser = message.author.id == userId.toString();
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Bubble(
          margin: const BubbleEdges.only(top: 8, right: 0, left: 0),
          padding: const BubbleEdges.symmetric(horizontal: 0, vertical: 0),
          elevation: 0,
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          radius: const Radius.circular(20),
          color: Colors.white,
          child: child,
        ),
        if (createdAt != null)
          Padding(
            padding: EdgeInsets.only(
              top: 6,
              right: isUser ? 4 : 0,
              left: isUser ? 0 : 4,
            ),
            child: Align(
              alignment: isUser ? Alignment.topRight : Alignment.topLeft,
              child: Text(
                textAlign: isUser ? TextAlign.right : TextAlign.left,
                DateTime.fromMillisecondsSinceEpoch(createdAt).time,
                style: AppTypography.nunito8SemiBold,
              ),
            ),
          ),
        if (nextMessageInGroup) const SizedBox(height: 8),
      ],
    );
  }

  void _onSendMessageTap(BuildContext context) {
    if (_textController.text.trim().isNotEmpty) {
      ChatScope.sendMessage(
        context,
        chatId: id.toString(),
        content: _textController.text,
      );
      _textController.clear();
      ChatsScope.getChatsList(context, userId);
    }
  }
}

class DateBuilder extends StatelessWidget {
  const DateBuilder({
    required this.dateTime,
    super.key,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        DateFormat('d MMMM y г.', 'ru').format(dateTime),
        style: TextStyle(color: context.theme.hintColor, fontSize: 12),
      ),
    );
  }
}
