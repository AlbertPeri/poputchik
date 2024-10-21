import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats_list.freezed.dart';
part 'chats_list.g.dart';

@freezed
class ChatsList with _$ChatsList {
  const factory ChatsList({
    @JsonKey(name: 'data') required List<Chats> chatList,
  }) = _ChatsList;

  factory ChatsList.fromJson(Map<String, dynamic> json) =>
      _$ChatsListFromJson(json);
}
