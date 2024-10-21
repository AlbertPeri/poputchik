import 'package:companion/src/feature/chats/models/latest_message.dart/latest_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats.freezed.dart';
part 'chats.g.dart';

@freezed
class Chats with _$Chats {
  const factory Chats({
    required int chatId,
    required int creatorId,
    required String creatorName,
    required String creatorMainImage,
    required int targetId,
    required String targetName,
    required String targetMainImage,
    required LatestMessage? latestMessage,
    required int? senderBlockId,
  }) = _Chats;

  const factory Chats.empty({
    @Default(0) int chatId,
    @Default(0) int creatorId,
    @Default('') String creatorName,
    @Default('') String creatorMainImage,
    @Default(0) int targetId,
    @Default('') String targetName,
    @Default('') String targetMainImage,
    LatestMessage? latestMessage,
    int? senderBlockId,
  }) = _Empty;

  factory Chats.fromJson(Map<String, dynamic> json) => _$ChatsFromJson(json);
}
