part of 'user_routes_bloc.dart';

@freezed
class UserRoutesEvent with _$UserRoutesEvent {
  const factory UserRoutesEvent.getRoutes() = _GetRoutes;
  const factory UserRoutesEvent.deleteRoute({required int id}) = _DeleteRoute;
  const factory UserRoutesEvent.completeRoute({required int id}) =
      _CompleteRoute;
}
