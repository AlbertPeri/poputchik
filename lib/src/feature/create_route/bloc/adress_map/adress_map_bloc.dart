import 'package:companion/src/feature/create_route/data/adresses_exception.dart';
import 'package:companion/src/feature/create_route/data/adresses_repository.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:l/l.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart' show Point;

part 'adress_map_bloc.freezed.dart';
part 'adress_map_event.dart';
part 'adress_map_state.dart';

const _debounceDuration = Duration(milliseconds: 400);

EventTransformer<Event> _debouncer<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class AdressMapBloc extends Bloc<AdressMapEvent, AdressMapState> {
  AdressMapBloc({
    required IAdressesRepository adressesRepository,
  })  : _adressesRepository = adressesRepository,
        super(const _Idle()) {
    on<_GeocodePoint>(
      _geocodePoint,
      transformer: _debouncer(_debounceDuration),
    );
  }

  final IAdressesRepository _adressesRepository;

  Future<void> _geocodePoint(
    _GeocodePoint event,
    Emitter<AdressMapState> emit,
  ) async {
    l.d('geocode point ${event.point}...');
    emit(const _Loading());
    try {
      final adress =
          await _adressesRepository.geocodeFromPoint(point: event.point);
      emit(
        Loaded(
          adressGeoData: AddressGeoData(address: adress, point: event.point),
        ),
      );
    } on AdressesException catch (error) {
      emit(_Error(message: error.message!));
      emit(const _Idle());
    }
  }
}
