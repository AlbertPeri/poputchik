// ignore_for_file: unnecessary_getters_setters, avoid_setters_without_getters

import 'package:companion/src/core/core.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

mixin MapScopeMixin {
  late YandexMapController _mapController;
  late final ILocationService _locationService;

  late double _latitudeOffset;

  double get latitudeOffset => _latitudeOffset;

  MapAlignment get logoAlignment => const MapAlignment(
        horizontal: HorizontalAlignment.right,
        vertical: VerticalAlignment.top,
      );

  bool get rotateGesturesEnabled => false;

  set mapController(YandexMapController controller) =>
      _mapController = controller;

  set locationService(ILocationService service) => _locationService = service;

  YandexMapController get mapController => _mapController;

  Future<bool> checkStatus() => _locationService.checkStatus();

  Future<UserLocationView> onUserLocationAdded(UserLocationView view) async {
    await _zoomToUser();
    return view;
  }

  Future<void> _zoomToUser() async {
    final userLocation = await _mapController.getUserCameraPosition();
    if (userLocation != null) {
      await _mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: userLocation.target.latitude - _latitudeOffset,
              longitude: userLocation.target.longitude,
            ),
            zoom: 18,
          ),
        ),
        animation: const MapAnimation(duration: 1.5),
      );
    }
  }

  Future<void> toggleUserLayer() async {
    await _mapController.toggleUserLayer(
      visible: true,
    );
    await _zoomToUser();
  }

  void calculateLatitudeOffset({required double mapViewHeight}) {
    const exampleDeviceMVH = 482.80952;
    const exampleDeviceLatOff = 0.0005;
    _latitudeOffset = (mapViewHeight * exampleDeviceLatOff) / exampleDeviceMVH;
  }
}
