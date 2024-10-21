part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.sendPhone({
    required String phone,
  }) = _SendPhone;

  const factory AuthEvent.checkAuthCode({
    required String verificationCode,
  }) = _CheckAuthCode;

  const factory AuthEvent.logout() = _LogOut;
}
