part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.updateUser(
    User? user,
  ) = _UpdateUser;

  const factory UserEvent.fetchUser() = _FetchUser;

  const factory UserEvent.editUserProfile({
    User? user,
  }) = _EditUserProfile;
}
