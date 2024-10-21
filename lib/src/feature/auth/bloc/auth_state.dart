part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.idle({
    User? user,
    String? phone,
  }) = _IdleAuth;

  const factory AuthState.notAuth({
    User? user,
    String? phone,
  }) = _UnAuth;

  const factory AuthState.loading({
    User? user,
    String? phone,
  }) = _LoadingAuth;

  const factory AuthState.phonSend({
    required String phone,
    User? user,
    String? message,
  }) = _SentAuthPhone;

  const factory AuthState.error({
    User? user,
    String? message,
    String? phone,
  }) = _ErrorAuth;

  const factory AuthState.authenticated({
    required String userId,
    required User user,
    String? phone,
    String? message,
  }) = _Auth;
}
