part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const UserState._();
  const factory UserState.initial({
    User? user,
  }) = _UserInitialState;

  const factory UserState.updating({
    User? user,
  }) = _UserUpdatingState;

  const factory UserState.loaded({
    User? user,
  }) = _UserLoadedlState;

  const factory UserState.error({
    User? user,
    String? error,
  }) = _UserErrorState;

  // If an error has occurred
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isIdling => !isProcessing;

  bool get isLoaded => maybeMap<bool>(orElse: () => false, loaded: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, updating: (_) => true);
}
