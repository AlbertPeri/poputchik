import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/adress_map/adress_map_bloc.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart' show Point;

class AdressMapScope extends StatelessWidget {
  const AdressMapScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope =
      BlocScope<AdressMapEvent, AdressMapState, AdressMapBloc>();

  static ScopeData<AddressGeoData?> get geoDataOrNull => _scope.select(
        (state) => state.maybeMap(
          orElse: () => null,
          loaded: (data) => data.adressGeoData,
        ),
      );

  static ScopeData<String> get buttonText => _scope.select(
        (state) => state.maybeWhen(
          idle: () => 'Выберите адрес на карте',
          loading: () => 'Загрузка...',
          loaded: (adress) => adress.address!,
          orElse: () => '',
        ),
      );

  static ScopeData<bool> get adressIsLoaded => _scope.select(
        (state) => state.maybeWhen(
          loaded: (adress) => true,
          orElse: () => false,
        ),
      );

  static UnaryScopeMethod<Point> get geocodePoint => _scope.unary(
        (context, point) => AdressMapEvent.geocodePoint(point: point),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdressMapBloc>(
      create: (context) => AdressMapBloc(
        adressesRepository: context.repository.adressesRepository,
      ),
      child: child,
    );
  }
}
