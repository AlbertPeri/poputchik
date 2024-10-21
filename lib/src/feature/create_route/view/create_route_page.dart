import 'dart:io';

import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/adress_map/adress_map_bloc.dart'
    hide Loaded;
import 'package:companion/src/feature/create_route/bloc/adresses_list/adresses_list_bloc.dart';
import 'package:companion/src/feature/create_route/bloc/create_route/create_route_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/scope/adress_map_scope.dart';
import 'package:companion/src/feature/create_route/scope/create_route_map_scope.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:companion/src/feature/create_route/widget/adress_map_bottom_sheet/adress_map_bottom_sheet.dart';
import 'package:companion/src/feature/create_route/widget/adresses_list_bottom_sheet/adress_text_field/adress_text_field.dart';
import 'package:companion/src/feature/create_route/widget/adresses_list_bottom_sheet/adresses_list_bottom_sheet.dart';
import 'package:companion/src/feature/create_route/widget/opacity_and_positioned_builder/opacity_and_positioned_builder.dart';
import 'package:companion/src/feature/create_route/widget/route_info_bottom_sheet/route_info_bottom_sheet.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:throttling/throttling.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({
    super.key,
    this.routeToEdit,
  });

  final Route? routeToEdit;

  @override
  State<CreateRoutePage> createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  late final CreateRouteMapScope _mapScope;
  late final RenderParametersManager<dynamic> _renderManager;
  late AdressType _selectedAdressType;
  static const _mainSheetKey = 'main_sheet';
  static const _mapSheetKey = 'map_sheet';
  double _bottomPadding = 0;
  bool _showMainSheet = true;
  final _hideGeoAdressOverlay = ValueNotifier<bool>(false);
  final _opacityDebouncer = Debouncing<void>(
    duration: const Duration(milliseconds: 350),
  );

  @override
  void initState() {
    _mapScope = CreateRouteMapScope();
    _renderManager = RenderParametersManager<dynamic>();
    super.initState();
    _calculateBottomPadding();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CreateRouteScope.initialize(context, widget.routeToEdit);
    });
  }

  @override
  void dispose() {
    _opacityDebouncer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateRouteBloc, CreateRouteState>(
          listener: _createRouteListener,
          listenWhen: _createRouteListenWhen,
        ),
        BlocListener<AdressMapBloc, AdressMapState>(
          listener: _adressMapListener,
        ),
        BlocListener<AdressesListBloc, AdressesListState>(
          listener: _adressesListListener,
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              bottom: Platform.isIOS,
              child: YandexMap(
                rotateGesturesEnabled: _mapScope.rotateGesturesEnabled,
                logoAlignment: _mapScope.logoAlignment,
                onMapCreated: (controller) async {
                  await _mapScope.initScope(
                    controller: controller,
                    mapViewHeight:
                        context.calculateMapViewHeight() - _bottomPadding,
                    context: context,
                  );
                  if (context.mounted) {
                    await _requestLocation(context);
                  }
                },
                onCameraPositionChanged:
                    (cameraPosition, _, finished, ___) async {
                  if (!_showMainSheet) {
                    AdressMapScope.geocodePoint(context, cameraPosition.target);
                    await _handleOpacityDebounce(finished: finished);
                  }
                },
                mapObjects: _mapScope.mapObjects,
                onUserLocationAdded: _mapScope.onUserLocationAdded,
              ),
            ),
            if (!_showMainSheet)
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 31.5),
                  child: IgnorePointer(
                    child: Assets.icons.icLocationPin.svg(),
                  ),
                ),
              ),
            Positioned(
              top: 6,
              left: 20,
              child: SafeArea(
                child: PopButton(
                  onTap: _showMainSheet
                      ? () => context.pop()
                      : () => _toggleMainSheet(open: true),
                ),
              ),
            ),
            OpacityAndPositionedBulder(
              valueListenable: _hideGeoAdressOverlay,
              addPositionedListenable: true,
              bottomPadding: _bottomPadding,
              child: LocationButton(
                onTap: () => _requestLocation(context),
                icon: Assets.icons.icLocation.svg(
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _showMainSheet
            ? RenderMetricsObject(
                id: _mainSheetKey,
                manager: _renderManager,
                child: RouteInfoBottomSheet(
                  adressModal: _openAdressesListSheet,
                  editRoute: widget.routeToEdit != null,
                ),
              )
            : RenderMetricsObject(
                id: _mapSheetKey,
                manager: _renderManager,
                child: OpacityAndPositionedBulder(
                  valueListenable: _hideGeoAdressOverlay,
                  child: AdressMapBottomSheet(
                    adressType: _selectedAdressType,
                    onPop: () => _toggleMainSheet(open: true),
                    onTap: () => _openAdressesListSheet(
                      context,
                      _selectedAdressType,
                      showMapButton: false,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _handleOpacityDebounce({required bool finished}) async {
    if (!finished) {
      _hideGeoAdressOverlay.value = !finished;
    } else {
      await _opacityDebouncer
          .debounce(() => _hideGeoAdressOverlay.value = !finished);
    }
  }

  void _toggleMainSheet({required bool open}) {
    setState(() {
      _showMainSheet = open;
      _calculateBottomPadding();
    });
  }

  void _calculateBottomPadding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final mainSheetHeight =
            _renderManager.getRenderData(_mainSheetKey)?.height;
        final mapSheetHeight =
            _renderManager.getRenderData(_mapSheetKey)?.height;
        _bottomPadding = mainSheetHeight ?? mapSheetHeight ?? 0;
      });
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

  Future<void> _openAdressesListSheet(
    BuildContext context,
    AdressType adressType, {
    bool? showMapButton,
  }) async {
    final sheetHeight = MediaQuery.sizeOf(context).height - 50;
    _selectedAdressType = adressType;

    final returnedData = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      elevation: 0,
      constraints:
          BoxConstraints(maxHeight: sheetHeight, minHeight: sheetHeight),
      barrierColor: AppColors.barrierColor,
      builder: (context) {
        return AdressesListBottomSheet(
          adressType: _selectedAdressType,
          showMapButton: showMapButton ?? true,
        );
      },
    );
    if (returnedData is String && returnedData == goToMapPopValue) {
      if (context.mounted) {
        _toggleMainSheet(open: false);
      }
    } else if (returnedData != null) {
      _toggleMainSheet(open: true);
    }
  }

  // Bloc Listeners
  void _adressesListListener(BuildContext context, AdressesListState state) {
    state.maybeWhen(
      error: (message) => context.toastService.showError(message),
      orElse: () {},
    );
  }

  void _adressMapListener(BuildContext context, AdressMapState state) {
    state.maybeWhen(
      error: (message) => context.toastService.showError(message),
      orElse: () {},
    );
  }

  void _createRouteListener(BuildContext context, CreateRouteState state) {
    final isLoadedOrNull = state.mapOrNull(loaded: (value) => value);
    if (isLoadedOrNull != null) {
      _mapScope.generatePlacemarks(isLoadedOrNull);
    }
    _calculateBottomPadding();
    state.maybeWhen(
      error: (message) => context.toastService.showError(message),
      submitted: () {
        context.toastService.showSuccess('Поездка создана!');
        context.pop('update');
      },
      edited: () {
        context.toastService.showSuccess('Данные поездки изменены!');
        context.pop('update');
      },
      orElse: () {},
    );
  }

  bool _createRouteListenWhen(
    CreateRouteState pr,
    CreateRouteState cu,
  ) =>
      cu.maybeWhen(
        submitted: () => true,
        edited: () => true,
        error: (_) => true,
        loaded: (cuId, cuDepData, cuArrData, __, ___) {
          return pr.maybeWhen(
            loaded: (prId, prDepData, prArrData, __, ___) {
              // print(prDepData?.point);
              // print(prArrData?.point);

              return cuDepData?.point != prDepData?.point ||
                  cuArrData?.point != prArrData?.point ||
                  cuId != prId;
            },
            loading: (_) => true,
            error: (_) => true,
            orElse: () => false,
          );
        },
        orElse: () => false,
      );
}
