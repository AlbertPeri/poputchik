import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/router/router.dart';
import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatsItem extends StatelessWidget {
  const ChatsItem({
    required this.chatsItem,
    super.key,
  });

  final Chats chatsItem;

  Future<void> _openChat(BuildContext context, int? latestMessageId) =>
      context.pushNamed(
        RouteNames.chat,
        extra: chatsItem,
        queryParameters: {
          'latestMessageId': latestMessageId?.toString(),
        },
      );

  @override
  Widget build(BuildContext context) {
    final latestMessage = chatsItem.latestMessage;
    final isUnread = latestMessage != null &&
        // value.contains(chatsItem.chatId.toString()) ||
        // value.contains(chatsItem.targetName) ||
        !latestMessage.isSeen &&
        !(latestMessage.userId == UserScope.userOf(context).id);
    final creatorIsUser =
        chatsItem.creatorId == UserScope.userOf(context, listen: true).id;
    return InkWell(
      onTap: () => _openChat(context, chatsItem.latestMessage?.id),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              foregroundImage: NetworkImage(
                chatsItem.targetMainImage,
              ),
              backgroundImage:
                  AssetImage(Assets.images.imDefaultProfilePic.path),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 4),
                  Text(
                    creatorIsUser
                        ? chatsItem.targetName
                        : chatsItem.creatorName,
                    style: AppTypography.sfPro17Medium,
                  ),
                  Text(
                    chatsItem.latestMessage?.content ?? '',
                    style: AppTypography.nunito10Regular,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            if (isUnread)
              const ClipOval(
                child: SizedBox.square(
                  dimension: 8,
                  child: ColoredBox(color: Colors.black),
                ),
              ),
            const SizedBox(width: 13),
          ],
        ),
      ),
    );
  }
}
