import 'package:freezed_annotation/freezed_annotation.dart';

part 'latest_message.freezed.dart';
part 'latest_message.g.dart';

@freezed
class LatestMessage with _$LatestMessage {
  const factory LatestMessage({
    required int id,
    required String? content,
    required String createdAt,
    required int userId,
    @Default(true) bool isSeen,
  }) = _LatestMessage;

  factory LatestMessage.fromJson(Map<String, dynamic> json) =>
      _$LatestMessageFromJson(json);
}
