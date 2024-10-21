import 'package:companion/src/feature/create_route/data/adresses_exception.dart';
import 'package:companion/src/feature/create_route/data/adresses_repository.dart';
import 'package:companion/src/feature/create_route/model/address_list_data/address_list_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:l/l.dart';
import 'package:stream_transform/stream_transform.dart';

part 'adresses_list_bloc.freezed.dart';
part 'adresses_list_event.dart';
part 'adresses_list_state.dart';

const _debounceDuration = Duration(milliseconds: 400);

EventTransformer<Event> _debouncer<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class AdressesListBloc extends Bloc<AdressesListEvent, AdressesListState> {
  AdressesListBloc({
    required IAdressesRepository adressesRepository,
  })  : _adressesRepository = adressesRepository,
        super(const _Idle()) {
    on<_SearchByQuery>(
      _searchByQuery,
      transformer: _debouncer(_debounceDuration),
    );
  }

  final IAdressesRepository _adressesRepository;

  Future<void> _searchByQuery(
    _SearchByQuery event,
    Emitter<AdressesListState> emit,
  ) async {
    l.d('search with query - ${event.query}...');
    emit(const _Loading());
    try {
      final adresses =
          await _adressesRepository.getAdresses(query: event.query);
      final formattedAdresses = adresses.results?.map(
            (result) {
              final title = result.title?.text.trim();
              final subtitle = result.subtitle?.text.trim();
              final full = result.address?.formattedAddress.trim();
              return AddressListData(
                title: title,
                subtitle: subtitle,
                full: full,
              );
            },
          ).toList() ??
          [];
      if (formattedAdresses.every((adress) => adress.isEmpty)) {
        emit(const _Loaded(adresses: []));
      } else {
        emit(_Loaded(adresses: formattedAdresses));
      }
    } on AdressesException catch (error) {
      emit(_Error(message: error.message!));
    }
  }
}
