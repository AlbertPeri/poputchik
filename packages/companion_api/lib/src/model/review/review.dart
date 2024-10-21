import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
sealed class ReviewResponse with _$ReviewResponse {
  const factory ReviewResponse({
    required int id,
    required String? content,
    required double? rating,
    required String createdAt,
    required String? senderName,
    required String? senderSurname,
    required String? senderPatronymic,
  }) = _ReviewResponse;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);
}
