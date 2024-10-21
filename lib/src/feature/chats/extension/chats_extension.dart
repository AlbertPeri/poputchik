import 'package:companion/src/config/app_config.dart';
import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:companion/src/feature/chats/models/chats_list/chats_list.dart';
import 'package:companion/src/feature/chats/models/latest_message.dart/latest_message.dart';
import 'package:companion_api/companion.dart';

extension ChatsResponseX on ChatsResponse {
  Chats toChats() {
    return Chats(
      chatId: chatId,
      creatorId: creatorId,
      creatorName: creatorName ?? 'Аноним ($targetId)',
      creatorMainImage: _parseImageUrl(creatorMainImage),
      targetId: targetId,
      targetName: targetName ?? 'Аноним ($creatorId)',
      targetMainImage: _parseImageUrl(targetMainImage),
      latestMessage: latestMessage?.toLatestMessage(),
      senderBlockId: senderBlockId,
    );
  }

  String _parseImageUrl(String? image) {
    const defaultImagePath = 'image/default-profile-pic.jpg';

    return image != null && image.contains(defaultImagePath)
        ? AppConfig.baseUrl + image
        : (image ?? defaultImagePath);
  }
}

extension ChatsListRepositoryX on ChatsListResponse {
  ChatsList toChatsList() => ChatsList(
        chatList: chatList
            .map((e) => e.toChats())
            .where((element) => element.latestMessage != null)
            .toList()
          ..sort(
            (a, b) {
              final createdAtB = b.latestMessage?.createdAt;
              return createdAtB != null
                  ? a.latestMessage?.createdAt.compareTo(createdAtB) ?? 0
                  : 0;
            },
          ),
      );
}

extension LatestMessageResponseX on LatestMessageResponse {
  LatestMessage toLatestMessage() => LatestMessage(
        id: id,
        content: content ?? '',
        createdAt: createdAt,
        isSeen: isSeen,
        userId: authorId,
      );
}
