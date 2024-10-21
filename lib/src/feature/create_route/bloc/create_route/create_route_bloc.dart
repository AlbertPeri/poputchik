import 'package:companion/src/feature/create_route/data/adresses_exception.dart';
import 'package:companion/src/feature/create_route/data/adresses_repository.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_exception.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

part 'create_route_bloc.freezed.dart';
part 'create_route_event.dart';
part 'create_route_state.dart';

class CreateRouteBloc extends Bloc<CreateRouteEvent, CreateRouteState> {
  CreateRouteBloc({
    required IUserRoutesRepository userRoutesRepository,
    required IAdressesRepository adressesRepository,
  })  : _userRoutesRepository = userRoutesRepository,
        _adressesRepository = adressesRepository,
        super(const Loaded()) {
    on<_ChangeData>(_changeData);
    on<_ChangeDepartureDate>(_changeDepartureDate);
    on<_ChangePeopleAmount>(_changePeopleAmount);
    on<_Initialize>(_initialize);
    on<_Submit>(_submit);
  }

  final IUserRoutesRepository _userRoutesRepository;
  final IAdressesRepository _adressesRepository;

  Future<void> _changeData(
    _ChangeData event,
    Emitter<CreateRouteState> emit,
  ) async {
    if (state is! Loaded) {
      throw Exception('STATE NOT LOADED'); // test
    }
    final stateCopy = state as Loaded;
    if (event.data.point != null) {
      switch (event.adressType) {
        case AdressType.departure:
          emit(stateCopy.copyWith(departureData: event.data));
        case AdressType.arrival:
          emit(stateCopy.copyWith(arrivalData: event.data));
      }
      return;
    }

    switch (event.adressType) {
      case AdressType.departure:
        emit(const _Loading(adressType: AdressType.departure));
      case AdressType.arrival:
        emit(const _Loading(adressType: AdressType.arrival));
    }
    try {
      final point = await _adressesRepository.geocodeFromAdress(
        adress: event.data.address!,
      );
      switch (event.adressType) {
        case AdressType.departure:
          emit(
            stateCopy.copyWith(
              departureData: AddressGeoData(
                point: point,
                address: event.data.address,
              ),
            ),
          );
        case AdressType.arrival:
          emit(
            stateCopy.copyWith(
              arrivalData: AddressGeoData(
                point: point,
                address: event.data.address,
              ),
            ),
          );
      }
    } on AdressesException catch (error) {
      emit(_Error(message: error.message!));
      emit(stateCopy);
    }
  }

  void _changeDepartureDate(
    _ChangeDepartureDate event,
    Emitter<CreateRouteState> emit,
  ) {
    if (state is Loaded) {
      emit((state as Loaded).copyWith(departureDate: event.date));
    }
  }

  void _changePeopleAmount(
    _ChangePeopleAmount event,
    Emitter<CreateRouteState> emit,
  ) {
    if (state is Loaded) {
      emit((state as Loaded).copyWith(peopleAmount: event.count));
    }
  }

  void _initialize(_Initialize event, Emitter<CreateRouteState> emit) {
    if (event.route != null) {
      final route = event.route!;
      emit(
        Loaded(
          routeIdToEdit: route.id,
          departureData: AddressGeoData(
            address: route.startPlace,
            point: Point(
              latitude: route.latitudeA,
              longitude: route.longitudeA,
            ),
          ),
          arrivalData: AddressGeoData(
            address: route.endPlace,
            point: Point(
              latitude: route.latitudeB,
              longitude: route.longitudeB,
            ),
          ),
          departureDate: route.date,
          peopleAmount: route.peopleAmount,
        ),
      );
    } else {
      emit(const Loaded());
    }
  }

  Future<void> _submit(_Submit event, Emitter<CreateRouteState> emit) async {
    if (state is! Loaded) return;
    final loadedState = state as Loaded;
    if (loadedState.departureDate!.isBefore(DateTime.now())) {
      emit(
        const _Error(message: 'Выбранное время уже наступило, укажите другое'),
      );
      emit(loadedState);
      return;
    }
    try {
      if (loadedState.routeIdToEdit != null) {
        await _userRoutesRepository.updateRoute(
          routeId: loadedState.routeIdToEdit!,
          startPlace: loadedState.departureData!.address!,
          endPlace: loadedState.arrivalData!.address!,
          startPoint: loadedState.departureData!.point!,
          endPoint: loadedState.arrivalData!.point!,
          peopleAmount: loadedState.peopleAmount,
          date: loadedState.departureDate!,
        );
        emit(const _Edited());
      } else {
        await _userRoutesRepository.postUserRoute(
          peopleAmount: loadedState.peopleAmount,
          date: loadedState.departureDate!,
          startPlace: loadedState.departureData!.address!,
          endPlace: loadedState.arrivalData!.address!,
          startPoint: loadedState.departureData!.point!,
          endPoint: loadedState.arrivalData!.point!,
        );
        emit(const _Submitted());
      }
    } on UserRoutesException catch (error) {
      emit(_Error(message: error.message!));
      emit(loadedState);
    }
  }
}
