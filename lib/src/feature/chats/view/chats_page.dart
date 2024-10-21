import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/chats/bloc/chats_bloc.dart';
import 'package:companion/src/feature/chats/widget/chats_item/chats_item.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void showDeleteChatDialog(
    BuildContext context, {
    required String chatId,
    required int userId,
  }) =>
      AppDialog.showCustomDialog(
        context,
        title: 'Удалить чат?',
        actionTitle: 'Да',
        onActionTap: () {
          ChatsScope.deleteChat(
            context,
            int.parse(chatId),
            userId,
          );
          context.pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    final userId = UserScope.userOf(context).id;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                'Чаты',
                style: AppTypography.sfPro30Medium.copyWith(
                  height: 45 / 30,
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            setState(() {
              ChatsScope.updateChatList(context, userId);
            });
          },
          child: CustomScrollView(
            slivers: [
              BlocConsumer<ChatsBloc, ChatsState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) => state.whenOrNull(
                  error: (routesList, message) =>
                      context.toastService.showError(
                    'Ошибка, повторите попытку позже',
                  ),
                ),
                builder: (context, state) {
                  final chatsList = state.chatsList?.copyWith(
                    chatList: state.chatsList?.chatList.reversed.toList() ?? [],
                  );
                  return state.maybeWhen(
                    // processing: (chatsList) => const SliverFillRemaining(
                    //   child: Loader(),
                    // ),
                    error: (chatsList, message) => const SliverFillRemaining(
                      child: Center(
                        child: Text('Ошибка, повторите попытку позже'),
                      ),
                    ),
                    orElse: () {
                      if (chatsList == null || chatsList.chatList.isEmpty) {
                        return const SliverFillRemaining(
                          child: EmptyPlaceholder(),
                        );
                      } else {
                        final list = chatsList.chatList.toList();
                        return SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight * 2 + 24,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = list[index];
                                final chatId = item.chatId.toString();
                                return Dismissible(
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: const Color(0xFFFF3B30),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(
                                      Icons.delete,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  key: Key(item.toString()),
                                  confirmDismiss: (direction) {
                                    // Remove the item from the data source.
                                    AppDialog.showCustomDialog(
                                      context,
                                      title: 'Удалить чат?',
                                      actionTitle: 'Да',
                                      onActionTap: () {
                                        ChatsScope.deleteChat(
                                          context,
                                          int.parse(chatId),
                                          userId,
                                        );
                                        context.pop(true);
                                      },
                                    );

                                    return Future.value(false);
                                  },
                                  child: ChatsItem(
                                    key: ValueKey(chatId),
                                    chatsItem: item,
                                  ),
                                );
                              },
                              childCount: list.length,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
