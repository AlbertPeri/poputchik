import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
sealed class Review with _$Review {
  const factory Review({
    required int id,
    required String? content,
    required double? rating,
    required String createdAt,
    required String? senderName,
    required String? senderSurname,
    required String? senderPatronymic,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
