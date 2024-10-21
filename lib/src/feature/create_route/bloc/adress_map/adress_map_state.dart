part of 'adress_map_bloc.dart';

@freezed
class AdressMapState with _$AdressMapState {
  const factory AdressMapState.idle() = _Idle;
  const factory AdressMapState.loading() = _Loading;
  const factory AdressMapState.error({required String message}) = _Error;
  const factory AdressMapState.loaded({
    required AddressGeoData adressGeoData,
  }) = Loaded;
}
