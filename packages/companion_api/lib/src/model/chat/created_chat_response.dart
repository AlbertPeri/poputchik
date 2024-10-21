import 'package:freezed_annotation/freezed_annotation.dart';

part 'created_chat_response.freezed.dart';
part 'created_chat_response.g.dart';

@freezed
class CreatedChatResponse with _$CreatedChatResponse {
  factory CreatedChatResponse({
    @Default(false) bool success,
    CreatedChat? chat,
  }) = _CreatedChatResponse;

  factory CreatedChatResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedChatResponseFromJson(json);
}

@freezed
class CreatedChat with _$CreatedChat {
  factory CreatedChat({
    int? id,
  }) = _CreatedChat;

  factory CreatedChat.fromJson(Map<String, dynamic> json) =>
      _$CreatedChatFromJson(json);
}
