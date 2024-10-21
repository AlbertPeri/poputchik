part of 'route_info_bloc.dart';

@freezed
class RouteInfoState with _$RouteInfoState {
  const factory RouteInfoState.loading() = _Loading;
  const factory RouteInfoState.error({required String message}) = _Error;
  const factory RouteInfoState.loaded({required User user}) = _Loaded;
}
