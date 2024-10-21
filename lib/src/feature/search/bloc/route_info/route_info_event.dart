part of 'route_info_bloc.dart';

@freezed
class RouteInfoEvent with _$RouteInfoEvent {
  const factory RouteInfoEvent.getUserInfo({String? userId}) = _GetUserInfo;
}
