part of 'user_routes_bloc.dart';

@freezed
class UserRoutesState with _$UserRoutesState {
  const factory UserRoutesState.loading() = _Loading;

  const factory UserRoutesState.error({
    required String message,
    @Default(false) bool actionError,
  }) = _Error;

  const factory UserRoutesState.loaded({
    required List<Route> routes,
  }) = _Loaded;

  const factory UserRoutesState.edited() = _Edited;

  const factory UserRoutesState.deleted() = _Deleted;

  const factory UserRoutesState.completed() = _Completed;
}
