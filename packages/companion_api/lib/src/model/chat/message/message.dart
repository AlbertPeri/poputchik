import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required int id,
    required String? content,
    required int userId,
    required int chatId,
    required String createdAt,
    required String updatedAt,
    @Default(true) bool isSeen,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, Object?> json) =>
      _$MessageResponseFromJson(json);
}
