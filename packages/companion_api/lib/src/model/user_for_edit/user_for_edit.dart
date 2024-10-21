import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_for_edit.freezed.dart';
part 'user_for_edit.g.dart';

@freezed
sealed class UserForEditResponse with _$UserForEditResponse {
  const factory UserForEditResponse({
    required String usersId,
    required String? name,
    required String? surname,
    required String? patronymic,
    required String? phoneNumber, // временно на бэке почему то налл приходит
    @JsonKey(name: 'hidePhone') required bool hidePhone,
  }) = _UserForEditResponse;

  factory UserForEditResponse.fromJson(Map<String, dynamic> json) =>
      _$UserForEditResponseFromJson(json);
}
