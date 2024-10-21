part of 'adresses_list_bloc.dart';

@freezed
class AdressesListEvent with _$AdressesListEvent {
  const factory AdressesListEvent.searchByQuery({
    required String query,
  }) = _SearchByQuery;
}
