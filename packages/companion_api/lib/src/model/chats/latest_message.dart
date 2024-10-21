import 'package:freezed_annotation/freezed_annotation.dart';

part 'latest_message.freezed.dart';
part 'latest_message.g.dart';

@freezed
class LatestMessageResponse with _$LatestMessageResponse {
  const factory LatestMessageResponse({
    required int id,
    required int authorId,
    required String createdAt,
    String? content,
    @Default(true) bool isSeen,
  }) = _LatestMessageResponse;

  factory LatestMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$LatestMessageResponseFromJson(json);
}
