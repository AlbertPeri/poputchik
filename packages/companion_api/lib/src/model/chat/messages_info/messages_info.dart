import 'package:companion_api/src/model/chat/messages/messages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_info.freezed.dart';
part 'messages_info.g.dart';

@freezed
class MessagesInfoResponse with _$MessagesInfoResponse {
  const factory MessagesInfoResponse({
    required bool success,
    required MessagesResponse messages,
  }) = _MessagesInfoResponse;

  factory MessagesInfoResponse.fromJson(Map<String, Object?> json) =>
      _$MessagesInfoResponseFromJson(json);
}
