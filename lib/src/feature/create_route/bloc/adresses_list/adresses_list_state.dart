part of 'adresses_list_bloc.dart';

@freezed
class AdressesListState with _$AdressesListState {
  const factory AdressesListState.idle() = _Idle;
  const factory AdressesListState.loading() = _Loading;
  const factory AdressesListState.error({required String message}) = _Error;
  const factory AdressesListState.loaded({
    required List<AddressListData> adresses,
  }) = _Loaded;
  // const factory AdressListState.selected({
  //   required AdressGeoData adressGeoData,
  // }) = _Selected;
}
