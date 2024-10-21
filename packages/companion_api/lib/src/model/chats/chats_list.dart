import 'package:companion_api/src/model/chats/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats_list.freezed.dart';
part 'chats_list.g.dart';

@freezed
class ChatsListResponse with _$ChatsListResponse {
  const factory ChatsListResponse({
    @JsonKey(name: 'data') required List<ChatsResponse> chatList,
  }) = _ChatsList;

  factory ChatsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatsListResponseFromJson(json);
}
