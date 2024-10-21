import 'package:companion_api/src/model/chats/latest_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats.freezed.dart';
part 'chats.g.dart';

@freezed
class ChatsResponse with _$ChatsResponse {
  const factory ChatsResponse({
    required int chatId,
    required int creatorId,
    required int targetId,
    String? creatorName,
    String? creatorMainImage,
    String? targetMainImage,
    LatestMessageResponse? latestMessage,
    String? targetName,
    int? senderBlockId,
  }) = _ChatsResponse;

  factory ChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatsResponseFromJson(json);
}
