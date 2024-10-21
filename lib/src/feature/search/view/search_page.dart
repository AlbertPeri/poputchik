import 'dart:async';
import 'dart:io';

import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/bloc/search/search_bloc.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/scope/route_info_scope.dart';
import 'package:companion/src/feature/search/scope/search_map_scope.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/bottom_sheet_service.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/route_info_bottom_sheet.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchMapScope _mapScope;

  @override
  void initState() {
    _mapScope = SearchMapScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          BlocConsumer<SearchBloc, SearchState>(
            listener: _searchListener,
            buildWhen: (_, current) => current.maybeWhen(
              loaded: (_) => true,
              orElse: () => false,
            ),
            builder: (context, state) {
              final routesOrNull = state.whenOrNull(
                loaded: (routes) => routes,
              );
              if (routesOrNull != null) {
                _mapScope.makePlacemarksFromRoutes(
                  routes: routesOrNull,
                  onPlacemarkTap: (route) => handlePlacemarkTap(
                    route,
                    context,
                  ),
                );
              }

              return SafeArea(
                child: YandexMap(
                  logoAlignment: _mapScope.logoAlignment,
                  rotateGesturesEnabled: _mapScope.rotateGesturesEnabled,
                  onMapCreated: (controller) async {
                    await _mapScope.initScope(
                      controller: controller,
                      mapViewHeight: 0,
                      context: context,
                      setStateCallback: _setStateCallback,
                    );
                  },
                  onCameraPositionChanged: _mapScope.onCameraPositionChanged,
                  onUserLocationAdded: _mapScope.onUserLocationAdded,
                  mapObjects: _mapScope.mapObjects,
                ),
              );
            },
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Column(
                children: [
                  if (_lastSelectedRoute != null) ...[
                    LocationButton(
                      onTap: () async {
                        await _showRouteInfoBottomSheet(
                          _lastSelectedRoute!,
                          context,
                        );
                      },
                      icon: Assets.icons.icCar.svg(
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  LocationButton(
                    onTap: () {
                      _requestLocation(context);
                    },
                    icon: Assets.icons.icLocation.svg(
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setStateCallback() {
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  Future<void> _requestLocation(BuildContext context) async {
    final locationEnabled = await _mapScope.checkStatus();
    if (locationEnabled) {
      await _mapScope.toggleUserLayer();
    } else if (context.mounted && Platform.isAndroid) {
      context.toastService.showError(
        'Не предоставлен доступ к местоположению пользователя',
      );
    }
  }

  Route? _lastSelectedRoute;

  Future<void> handlePlacemarkTap(Route route, BuildContext context) async {
    // // Проверяем, был ли этот маршрут уже выбран
    // if (_lastSelectedRoute == route) {
    //   // Если выбранный маршрут уже выбран ранее, то открываем BottomSheet
    //   await _showRouteInfoBottomSheet(route, context);
    // } else {
    //   // Если маршрут новый, выполняем зум на точки и сохраняем выбранный маршрут
    //await _mapScope.zoomPlacemark(route);
    _lastSelectedRoute = route;
    // }
  }

  Future<void> _showRouteInfoBottomSheet(
    Route route,
    BuildContext context,
  ) async {
    // Получаем информацию о пользователе
    RouteInfoScope.getUserInfo(context, route.usersId.toString());

    bottomSheetService.closeBottomSheet();

    // Создаем Completer, который будет завершен при закрытии BottomSheet
    final completer = Completer<void>();

    // Показываем BottomSheet и ждем его закрытия
    final bottomSheet = Scaffold.of(context).showBottomSheet(
      (context) => RouteInfoBottomSheet(route: route),
      clipBehavior: Clip.none,
      backgroundColor: AppColors.backgroundColor,
    );

    // Сохраняем ссылку на открытый BottomSheet
    bottomSheetService.setController(bottomSheet);

    // Обрабатываем закрытие BottomSheet
    await bottomSheet.closed.whenComplete(() {
      if (!completer.isCompleted) {
        completer.complete();
      }

      // Ваш код, который нужно выполнить после закрытия BottomSheet
      _mapScope.placemarkObjectsBClean();

      // Сбрасываем выбранный маршрут
      setState(() {
        _lastSelectedRoute = null;
      });
    });

    // Возвращаем Future из Completer
    return completer.future;
  }

  // Future<void> _showRouteInfoBottomSheet(Route route, BuildContext context) {
  //   RouteInfoScope.getUserInfo(context, route.usersId.toString());

  //   return Scaffold.of(context)
  //       .showBottomSheet(
  //         (context) => RouteInfoBottomSheet(route: route),
  //         clipBehavior: Clip.none,
  //         backgroundColor: AppColors.backgroundColor,
  //       )
  //       .closed;
  // }

  void _searchListener(BuildContext context, SearchState state) {
    state.maybeWhen(
      error: (message) => context.toastService.showError(message),
      orElse: () {},
    );
  }
}
