import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/chat/models/message/message.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.chatMessageData,
    super.key,
  });

  final Message chatMessageData;

  @override
  Widget build(BuildContext context) {
    //final isRead = chatMessageData.isRead != null && chatMessageData.isRead!;
    // const isRead = true;
    final padding = const EdgeInsets.all(12).copyWith(
      right: 15,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
              constraints: BoxConstraints(
                maxWidth: context.mediaQuery.size.width * 0.7,
              ),
              padding: padding,
              child: Text(chatMessageData.content ?? 'sdfdsf'),
            ),
            // if (isRead)
            //   Positioned(
            //     right: 5,
            //     bottom: 5,
            //     child: Assets.icons.icMessageRead.svg(),
            //   ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          chatMessageData.createdAt.parseDateTime().time,
          style: AppTypography.nunito8SemiBold,
        ),
      ],
    );
  }
}
