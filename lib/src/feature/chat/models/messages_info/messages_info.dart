import 'package:companion/src/feature/chat/models/messages/messages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_info.freezed.dart';
part 'messages_info.g.dart';

@freezed
class MessagesInfo with _$MessagesInfo {
  @JsonSerializable(explicitToJson: true)
  const factory MessagesInfo({
    required bool success,
    @JsonKey(name: 'messages') required Messages info,
  }) = _MessagesInfo;

  factory MessagesInfo.fromJson(Map<String, Object?> json) =>
      _$MessagesInfoFromJson(json);
}
