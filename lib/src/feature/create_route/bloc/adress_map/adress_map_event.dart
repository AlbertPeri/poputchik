part of 'adress_map_bloc.dart';

@freezed
class AdressMapEvent with _$AdressMapEvent {
  const factory AdressMapEvent.geocodePoint({
    required Point point,
  }) = _GeocodePoint;
}
