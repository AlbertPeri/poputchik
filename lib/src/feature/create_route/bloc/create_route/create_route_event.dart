part of 'create_route_bloc.dart';

@freezed
class CreateRouteEvent with _$CreateRouteEvent {
  const factory CreateRouteEvent.changeData({
    required AdressType adressType,
    required AddressGeoData data,
  }) = _ChangeData;
  const factory CreateRouteEvent.changeDepartureDate({
    required DateTime date,
  }) = _ChangeDepartureDate;
  const factory CreateRouteEvent.changePeopleAmount({
    required int count,
  }) = _ChangePeopleAmount;
  const factory CreateRouteEvent.initialize({Route? route}) = _Initialize;
  const factory CreateRouteEvent.submit() = _Submit;
}
