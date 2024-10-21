part of 'create_route_bloc.dart';

@freezed
class CreateRouteState with _$CreateRouteState {
  const factory CreateRouteState.loaded({
    int? routeIdToEdit,
    AddressGeoData? departureData,
    AddressGeoData? arrivalData,
    DateTime? departureDate,
    @Default(1) int peopleAmount,
  }) = Loaded;

  const factory CreateRouteState.loading({
    required AdressType adressType,
  }) = _Loading;

  const factory CreateRouteState.error({required String message}) = _Error;

  const factory CreateRouteState.submitted() = _Submitted;

  const factory CreateRouteState.edited() = _Edited;
}
