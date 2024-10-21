import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/create_route/create_route_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRouteScope extends StatelessWidget {
  const CreateRouteScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope =
      BlocScope<CreateRouteEvent, CreateRouteState, CreateRouteBloc>();

  static ScopeData<bool> get isLoading => _scope.select(
        (state) => state.maybeMap(
          orElse: () => false,
          loading: (_) => true,
        ),
      );

  static ScopeData<Loaded?> get loadedOrNull => _scope.select(
        (state) => state.maybeMap(
          orElse: () => null,
          loaded: (data) => data,
        ),
      );

  static ScopeData<bool> get buttonIsActive => _scope.select(
        (state) => state.maybeMap(
          orElse: () => false,
          loaded: (data) =>
              data.arrivalData != null &&
              data.departureData != null &&
              data.departureDate != null &&
              data.peopleAmount != 0,
        ),
      );

  static ScopeData<int?> get peopleAmountOrNull => _scope.select(
        (state) => state.maybeMap(
          orElse: () => null,
          loaded: (data) => data.peopleAmount,
        ),
      );

  static UnaryScopeMethod<Route?> get initialize => _scope.unary(
        (context, route) => CreateRouteEvent.initialize(route: route),
      );

  static void changeData(
    BuildContext context, {
    required AddressGeoData data,
    required AdressType adressType,
  }) =>
      context.read<CreateRouteBloc>().add(
            CreateRouteEvent.changeData(
              data: data,
              adressType: adressType,
            ),
          );

  static void changeDepartureDate(
    BuildContext context, {
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
  }) =>
      context.read<CreateRouteBloc>().add(
            CreateRouteEvent.changeDepartureDate(
              date: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              ),
            ),
          );

  static UnaryScopeMethod<int> get changePersonCount => _scope.unary(
        (context, count) => CreateRouteEvent.changePeopleAmount(count: count),
      );

  static NullaryScopeMethod get submit => _scope.nullary(
        (context) => const CreateRouteEvent.submit(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateRouteBloc>(
      create: (_) => CreateRouteBloc(
        userRoutesRepository: context.repository.userRoutesRepository,
        adressesRepository: context.repository.adressesRepository,
      ),
      child: child,
    );
  }
}
