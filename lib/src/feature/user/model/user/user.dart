import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required int id,
    required String? name,
    required String? surname,
    required String? patronymic,
    @JsonKey(name: 'hidePhone') required bool hidePhone,
    required String? image,
    required String? phoneNumber, // временно на бэке почему то налл приходит
    required double? averageRating,
    @JsonKey(name: 'reviewReceiver') required List<Review> reviewReceiver,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
