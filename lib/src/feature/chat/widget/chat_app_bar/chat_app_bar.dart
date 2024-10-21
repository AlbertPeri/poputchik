import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/typography/app_typography.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/widget/custom_menu_button.dart';
import 'package:companion/src/feature/chat/scope/chat_scope.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    required this.personName,
    required this.personId,
    required this.chatId,
    required this.onBlockStatusChanged,
    required this.isNotUserBlocked,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  final String personName;

  final String personId;

  final String? chatId;

  final void Function(bool) onBlockStatusChanged;

  final bool isNotUserBlocked;

  void _openProfile(BuildContext context) {
    context.pushNamed(
      RouteNames.personProfile,
      extra: {
        'personId': int.parse(personId),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Assets.icons.icArrowBack.svg(),
      ),
      leadingWidth: 68,
      titleSpacing: 10,
      toolbarHeight: 68,
      scrolledUnderElevation: 0,
      title: GestureDetector(
        onTap: () => _openProfile(context),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              foregroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(
                      avatarUrl!,
                    )
                  : null,
              backgroundImage:
                  AssetImage(Assets.images.imDefaultProfilePic.path),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personName.isEmpty ? 'Аноним' : personName,
                  style: AppTypography.sfPro17Bold.copyWith(letterSpacing: 1),
                ),
                // Text(
                //   'В сети',
                //   style: AppTypography.textSuperSmall12Medium.copyWith(
                //     color: AppColors.blueColor,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      actions: isNotUserBlocked
          ? [
              CustomMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                items: [
                  PopupMenuItemModel(
                    title: 'Заблокировать',
                    onTap: () => _showBlockDialog(context, personId),
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  void _showBlockDialog(
    BuildContext context,
    String targetId,
  ) =>
      AppDialog.showCustomDialog(
        context,
        title: 'Заблокировать пользователя?',
        actionTitle: 'Да',
        onActionTap: () {
          ChatScope.blockUser(
            context,
            senderId: UserScope.userOf(context).id.toString(),
            targetId: targetId,
          );
          ChatsScope.getChatsList(context, UserScope.userOf(context).id);
          // onBlockStatusChanged(false);
          context.pop();
        },
      );

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
