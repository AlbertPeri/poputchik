import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/utils/map_scope_mixin.dart';
import 'package:companion/src/feature/create_route/bloc/create_route/create_route_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/painting.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

class CreateRouteMapScope with MapScopeMixin {
  CreateRouteMapScope();

  PlacemarkMapObject? _depPlacemark;
  PlacemarkMapObject? _arrPlacemark;

  List<PlacemarkMapObject> get mapObjects => [
        if (_depPlacemark != null) _depPlacemark!,
        if (_arrPlacemark != null) _arrPlacemark!,
      ];

  Future<void> initScope({
    required BuildContext context,
    required YandexMapController controller,
    required double mapViewHeight,
  }) async {
    mapController = controller;
    locationService = context.locationService;
    calculateLatitudeOffset(mapViewHeight: mapViewHeight);
  }

  void generatePlacemarks(Loaded state) {
    // обрабатываю все возможные варианты, поскольку срабатывает несколько
    // анимаций перемещения камеры без обработки
    if (state.departureData != null) {
      if (state.arrivalData != null) {
        final arrChanged = _arrPlacemark?.point != state.arrivalData?.point;
        if (arrChanged) {
          if (state.arrivalData!.point == null) return;
          _generatePlacemarkAndMove(state.arrivalData!, AdressType.arrival);
        } else {
          if (state.departureData!.point == null) return;
          _generatePlacemarkAndMove(state.departureData!, AdressType.departure);
        }
      } else {
        if (state.departureData!.point == null) return;
        _generatePlacemarkAndMove(state.departureData!, AdressType.departure);
      }
    } else if (state.arrivalData != null) {
      if (state.arrivalData!.point == null) return;
      _generatePlacemarkAndMove(state.arrivalData!, AdressType.arrival);
    }
  }

  void _generatePlacemarkAndMove(
    AddressGeoData data,
    AdressType adressType, {
    bool? move = true,
  }) {
    switch (adressType) {
      case AdressType.departure:
        _depPlacemark = _createPlacemark(data, adressType);
      case AdressType.arrival:
        _arrPlacemark = _createPlacemark(data, adressType);
    }
    if (move!) {
      Future.delayed(Duration.zero, () async {
        await mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: data.point!.latitude - latitudeOffset,
                longitude: data.point!.longitude,
              ),
              zoom: 18,
            ),
          ),
          animation: const MapAnimation(
            duration: 1.5,
            type: MapAnimationType.linear,
          ),
        );
      });
    }
  }

  PlacemarkMapObject _createPlacemark(
    AddressGeoData adressGeoData,
    AdressType adressType,
  ) {
    final point = adressGeoData.point!;
    final text = switch (adressType) {
      AdressType.departure => 'Точка отправления',
      AdressType.arrival => 'Точка прибытия',
    };
    return PlacemarkMapObject(
      mapId: MapObjectId('Map Object ${adressGeoData.hashCode}'),
      point: Point(
        latitude: point.latitude,
        longitude: point.longitude,
      ),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            Assets.images.imLocationOutlined.path,
          ),
          anchor: const Offset(0.5, 1),
          //scale: 1.25,
        ),
      ),
      text: PlacemarkText(
        text: text,
        style: const PlacemarkTextStyle(
          size: 8,
          outlineColor: AppColors.white,
          color: AppColors.black,
          placement: TextStylePlacement.top,
        ),
      ),
      onTap: (placemarkObject, point) async {
        await mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
              zoom: 12,
            ),
          ),
          animation: const MapAnimation(duration: 0.5),
        );
      },
    );
  }

  // --- не работает изменение focusRect на андроид
  //
  // ScreenRect getFocusRect(Size sizeQuery, double sheetHeight) {
  //   final rect = ScreenRect(
  //     topLeft: const ScreenPoint(x: 0, y: 0),
  //     bottomRight: ScreenPoint(
  //       x: sizeQuery.width,
  //       y: sizeQuery.height - sheetHeight,
  //     ),
  //   );
  //   print(rect);
  //   return rect;
  // }
}
