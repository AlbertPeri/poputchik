import 'package:companion_api/src/model/review/review.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class UserResponse with _$UserResponse {
  const factory UserResponse({
    required int id,
    required String? name,
    required String? surname,
    required String? patronymic,
    @JsonKey(name: 'hidePhone') required bool hidePhone,
    required String? phoneNumber,
    required num? averageRating,
    required String? mainImage,
    @Default(<ReviewResponse>[]) List<ReviewResponse> myReviews,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
