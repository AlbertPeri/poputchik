import 'dart:async';
import 'dart:math';

import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/utils/map_scope_mixin.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/widget/cluster_icon_painter/cluster_icon_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:l/l.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

class SearchMapScope with MapScopeMixin {
  SearchMapScope();

  static const _iconScale = 1.0;
  static const _selectedIconScale = 1.25;

  var _placemarkObjectsA = <PlacemarkMapObject>[];
  final _placemarkObjectsB = <PlacemarkMapObject>[];
  PlacemarkMapObject? _selectedObject;
  double _mapZoom = 0;

  List<ClusterizedPlacemarkCollection> get mapObjects => [
        if (_placemarkObjectsA.isNotEmpty) _makeClusterizedCollection(),
      ];

  void placemarkObjectsBClean() {
    _placemarkObjectsB.clear();
  }

  Future<void> zoomPlacemark(Route route) async {
    await _zoomPlacemark(route);
  }

  VoidCallback? _setStateCallback;

  Future<void> initScope({
    required BuildContext context,
    required YandexMapController controller,
    required double mapViewHeight,
    required VoidCallback setStateCallback,
  }) async {
    mapController = controller;
    locationService = context.locationService;
    _setStateCallback = setStateCallback;
    calculateLatitudeOffset(mapViewHeight: mapViewHeight);
  }

  List<PlacemarkMapObject> _createPlacemarksA(
    List<Route> routes,
    Future<void> Function(Route route) onPlacemarkTap,
  ) {
    return routes
        .map(
          (route) => PlacemarkMapObject(
            mapId: MapObjectId('Route #${route.id} A'),
            point: Point(
              latitude: route.latitudeA,
              longitude: route.longitudeA,
            ),
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  (route.isMine
                          ? Assets.images.imMyLocationOutlined
                          : Assets.images.imLocationOutlined)
                      .path,
                ),
              ),
            ),
            onTap: (placemarkObject, __) {
              _zoomPlacemark(route);

              onPlacemarkTap(route).then((_) async {
                _repaintPlacemarks(isPlacemarkSelected: false);

                _selectedObject = null;
              });
              _showPointB(route); // Показать точку B при нажатии на точку A
            },
          ),
        )
        .toList();
  }

  Future<void> _showPointB(Route route) async {
    // Удаляем все предыдущие точки B
    _placemarkObjectsB.clear();

    // Добавляем точку B
    final pointB = PlacemarkMapObject(
      mapId: MapObjectId('Route #${route.id} B'),
      point: Point(
        latitude: route.latitudeB,
        longitude: route.longitudeB,
      ),
      opacity: 1,
      onTap: (mapObject, point) {},
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            route.isMine
                ? Assets.images.imMyLocationOutlined.path
                : Assets.images.imLocationOutlinedB.path,
          ),
        ),
      ),
    );

    // Убедитесь, что точка B не была добавлена ранее
    if (!_placemarkObjectsB.any((p) => p.mapId == pointB.mapId)) {
      _placemarkObjectsB.add(pointB);
      _setStateCallback?.call();
    }

    // Отдаляем карту, чтобы обе точки были видны
    await _zoomPlacemark(route);
  }

  bool _arePlacemarksDifferent(
    List<PlacemarkMapObject> oldPlacemarks,
    List<PlacemarkMapObject> newPlacemarks,
  ) {
    if (oldPlacemarks.length != newPlacemarks.length) {
      l.s('Number of placemarks differs');
      return true;
    }

    for (var i = 0; i < oldPlacemarks.length; i++) {
      if (oldPlacemarks[i].point != newPlacemarks[i].point ||
          oldPlacemarks[i].mapId != newPlacemarks[i].mapId) {
        l.s('Placemark position differs');
        return true;
      }
    }

    l.s('Placemarks are the same');
    return false;
  }

  void onCameraPositionChanged(
    CameraPosition cameraPosition,
    CameraUpdateReason reason,
    bool finished,
    VisibleRegion visibleRegion,
  ) {
    _mapZoom = cameraPosition.zoom;
  }

  void makePlacemarksFromRoutes({
    required List<Route> routes,
    required Future<void> Function(Route route) onPlacemarkTap,
  }) {
    final newPlacemarksA = _createPlacemarksA(routes, onPlacemarkTap);
    if (_arePlacemarksDifferent(_placemarkObjectsA, newPlacemarksA)) {
      l.s('Placemarks A updated: ${newPlacemarksA.length}');
      _placemarkObjectsA = newPlacemarksA;
      _setStateCallback?.call();
    }
  }

  double _calculateDistance(Point pointA, Point pointB) {
    const earthRadius = 6371000; // Радиус Земли в метрах
    final lat1 = pointA.latitude * pi / 180;
    final lat2 = pointB.latitude * pi / 180;
    final dLat = (pointB.latitude - pointA.latitude) * pi / 180;
    final dLon = (pointB.longitude - pointA.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    return distance;
  }

  Future<void> _zoomPlacemark(Route route) async {
    final pointA = Point(
      latitude: route.latitudeA,
      longitude: route.longitudeA,
    );
    final pointB = Point(
      latitude: route.latitudeB,
      longitude: route.longitudeB,
    );

    final distance = _calculateDistance(pointA, pointB);
    if (kDebugMode) {
      l.i(distance);
    }
    var padding = 0.05;
    if (distance >= 1000000) {
      padding = 0.6;
    } else if (distance < 1000000 && distance > 12000) {
      padding = 0.05;
    } else if (distance <= 12000) {
      padding = 0.007;
    }
    // final padding = distance > 1000000
    //     ? 0.6
    //     : 0.05; // Пример: если расстояние больше 5 км, увеличиваем отступ

    final bounds = BoundingBox(
      northEast: Point(
        latitude: max(route.latitudeA, route.latitudeB) + padding,
        longitude: max(route.longitudeA, route.longitudeB) + padding,
      ),
      southWest: Point(
        latitude: min(route.latitudeA, route.latitudeB) - padding,
        longitude: min(route.longitudeA, route.longitudeB) - padding,
      ),
    );

    // Переместите камеру, чтобы отобразить обе точки в центре карты
    await mapController.moveCamera(
      CameraUpdate.newGeometry(
        Geometry.fromBoundingBox(bounds),
      ),
      animation: const MapAnimation(duration: 0.5),
    );

    // Сбросить выбор маркеров
    _selectedObject = null;
    _repaintPlacemarks(isPlacemarkSelected: false);
  }

  // Future<void> _zoomPlacemark(Route route) async {
  //   final bounds = BoundingBox(
  //     northEast: Point(
  //       latitude:
  //           max(route.latitudeA, route.latitudeB) + 0.09, // увеличьте отступ
  //       longitude: max(route.longitudeA, route.longitudeB) + 0.09,
  //     ),
  //     southWest: Point(
  //       latitude: min(route.latitudeA, route.latitudeB) - 0.09,
  //       longitude: min(route.longitudeA, route.longitudeB) - 0.09,
  //     ),
  //   );

  //   // Переместите камеру, чтобы отобразить обе точки в центре карты
  //   await mapController.moveCamera(
  //     CameraUpdate.newGeometry(
  //       Geometry.fromBoundingBox(bounds),
  //     ),
  //     animation: const MapAnimation(duration: 0.5),
  //   );

  //   // Сбросить выбор маркеров
  //   _selectedObject = null;
  //   _repaintPlacemarks(isPlacemarkSelected: false);
  // }

  // Future<void> _zoomPlacemark(PlacemarkMapObject placemarkObject) async {
  //   await mapController.moveCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: Point(
  //           latitude: placemarkObject.point.latitude - 0.0005,
  //           longitude: placemarkObject.point.longitude,
  //         ),
  //         zoom: 18,
  //       ),
  //     ),
  //     animation: const MapAnimation(duration: 0.5),
  //   );

  //   if (placemarkObject == _selectedObject) return;
  //   if (_selectedObject != null) {
  //     _repaintPlacemarks(isPlacemarkSelected: false);
  //   }
  //   _selectedObject = placemarkObject;
  //   _repaintPlacemarks(isPlacemarkSelected: true);
  // }

  void _repaintPlacemarks({required bool isPlacemarkSelected}) {
    final indexA = _placemarkObjectsA.indexWhere(
      (obj) => obj.mapId == _selectedObject?.mapId,
    );
    if (indexA == -1) return;

    final stringIcon = _selectedObject?.icon?.toString() ?? '';
    final isMyRoute = stringIcon.contains('imMyLocation');
    final newImage = isPlacemarkSelected
        ? (isMyRoute ? Assets.images.imMyLocation : Assets.images.imLocation)
            .path
        : (isMyRoute
                ? Assets.images.imMyLocationOutlined
                : Assets.images.imLocationOutlined)
            .path;

    _placemarkObjectsA[indexA] = _selectedObject!.copyWith(
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(newImage),
          scale: isPlacemarkSelected ? _selectedIconScale : _iconScale,
        ),
      ),
    );
    l.s(_placemarkObjectsA[indexA].icon?.toJson() ?? '');
    _setStateCallback?.call();
  }

  ClusterizedPlacemarkCollection _makeClusterizedCollection() {
    return ClusterizedPlacemarkCollection(
      mapId: const MapObjectId('clusterized-1'),
      placemarks: _placemarkObjectsA + _placemarkObjectsB,
      radius: 50,
      minZoom: 15,
      onClusterAdded: (self, cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await ClusterIconPainter(cluster.size).getClusterIconBytes(),
                ),
              ),
            ),
          ),
        );
      },
      onClusterTap: (self, cluster) async {
        await mapController.moveCamera(
          animation: const MapAnimation(
            duration: 0.3,
          ),
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: cluster.placemarks.first.point,
              zoom: _mapZoom + 3,
            ),
          ),
        );
      },
    );
  }
}

// // ignore_for_file: avoid_positional_boolean_parameters

// import 'dart:async';

// import 'package:companion/gen/assets.gen.dart';
// import 'package:companion/src/core/core.dart';
// import 'package:companion/src/core/utils/map_scope_mixin.dart';
// import 'package:companion/src/feature/search/model/route/route.dart';

// import 'package:companion/src/feature/search/widget/cluster_icon_painter/cluster_icon_painter.dart';
// import 'package:flutter/widgets.dart' hide Route;
// import 'package:l/l.dart';
// import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

// class SearchMapScope with MapScopeMixin {
//   SearchMapScope();

//   static const _iconScale = 1.0;
//   static const _selectedIconScale = 1.25;

//   var _placemarkObjects = <PlacemarkMapObject>[];
//   final _placemarkObjectsB = <PlacemarkMapObject>[];
//   PlacemarkMapObject? _selectedObject;
//   double _mapZoom = 0;

//   List<ClusterizedPlacemarkCollection> get mapObjects => [
//         if (_placemarkObjects.isNotEmpty) _makeClusterizedCollection(),
//       ];

//   VoidCallback? _setStateCallback;

//   // AssetGenImage _getSelectedIcon(Route route) =>
//   //     route.isMine ? Assets.images.imMyLocation : Assets.images.imLocation;

//   // AssetGenImage _getUnselectedIcon(Route route) => route.isMine
//   //     ? Assets.images.imMyLocationOutlined
//   //     : Assets.images.imLocationOutlined;

//   Future<void> addPlacemark(Route route) async {
//     // final placemark = PlacemarkMapObject(
//     //   mapId: MapObjectId('Route #${route.id} B'),
//     //   point: Point(
//     //     latitude: route.latitudeB,
//     //     longitude: route.longitudeB,
//     //   ),
//     //   opacity: 1,
//     //   icon: PlacemarkIcon.single(
//     //     PlacemarkIconStyle(
//     //       image: BitmapDescriptor.fromAssetImage(
//     //         route.isMine
//     //             ? Assets.images.imMyLocationOutlined.path
//     //             : Assets.images.imLocationOutlined.path,
//     //       ),
//     //     ),
//     //   ),
//     //   onTap: (placemarkObject, __) async {
//     //     _repaintPlacemarks(isPlacemarkSelected: true);
//     //     _zoomPlacemark(placemarkObject);
//     //   },
//     // );
//     // _placemarkObjects.add(placemark);
//     // _setStateCallback?.call();
//   }

//   Future<void> initScope({
//     required BuildContext context,
//     required YandexMapController controller,
//     required double mapViewHeight,
//     required VoidCallback setStateCallback,
//   }) async {
//     mapController = controller;
//     locationService = context.locationService;
//     _setStateCallback = setStateCallback;
//     calculateLatitudeOffset(mapViewHeight: mapViewHeight);
//   }

//   List<PlacemarkMapObject> _createPlacemarks(
//     List<Route> routes,
//     Future<void> Function(Route route) onPlacemarkTap,
//   ) {
//     final placemarksA = routes
//         .map(
//           (route) => PlacemarkMapObject(
//             mapId: MapObjectId('Route #${route.id}'),
//             point: Point(
//               latitude: route.latitudeA,
//               longitude: route.longitudeA,
//             ),
//             opacity: 1,
//             icon: PlacemarkIcon.single(
//               PlacemarkIconStyle(
//                 image: BitmapDescriptor.fromAssetImage(
//                   (route.isMine
//                           ? Assets.images.imMyLocationOutlined
//                           : Assets.images.imLocationOutlined)
//                       .path,
//                 ),
//               ),
//             ),
//             onTap: (placemarkObject, __) {
//               onPlacemarkTap(route).then((_) async {
//                 _repaintPlacemarks(isPlacemarkSelected: false);
//                 _selectedObject = null;
//                 await _showPointB(route);
//               });
//               _zoomPlacemark(placemarkObject);
//             },
//           ),
//         )
//         .toList();

//     // final placemarksB = routes
//     //     .map(
//     //       (route) => PlacemarkMapObject(
//     //         mapId: MapObjectId('Route #${route.id} B'),
//     //         point: Point(
//     //           latitude: route.latitudeB,
//     //           longitude: route.longitudeB,
//     //         ),
//     //         opacity: 1,
//     //         icon: PlacemarkIcon.single(
//     //           PlacemarkIconStyle(
//     //             image: BitmapDescriptor.fromAssetImage(
//     //               (route.isMine
//     //                       ? Assets.images.imMyLocationOutlined
//     //                       : Assets.images.imLocationOutlinedB)
//     //                   .path,
//     //             ),
//     //           ),
//     //         ),
//     //         onTap: (placemarkObject, __) {
//     //           onPlacemarkTap(route).then((_) async {
//     //             _repaintPlacemarks(isPlacemarkSelected: false);
//     //             _selectedObject = null;
//     //           });
//     //           _zoomPlacemark(placemarkObject);
//     //         },
//     //       ),
//     //     )
//     //     .toList();

//     return placemarksA;
//   }

//   bool _arePlacemarksDifferent(
//     List<PlacemarkMapObject> oldPlacemarks,
//     List<PlacemarkMapObject> newPlacemarks,
//   ) {
//     if (oldPlacemarks.length != newPlacemarks.length) {
//       l.s('Number of placemarks differs');
//       return true;
//     }

//     for (var i = 0; i < oldPlacemarks.length; i++) {
//       if (oldPlacemarks[i].point != newPlacemarks[i].point ||
//           oldPlacemarks[i].mapId != newPlacemarks[i].mapId) {
//         l.s('Placemark position differs');
//         return true;
//       }
//     }

//     l.s('Placemarks are the same');

//     return false;
//   }

//   void onCameraPositionChanged(
//     CameraPosition cameraPosition,
//     CameraUpdateReason reason,
//     bool finished,
//     VisibleRegion visibleRegion,
//   ) {
//     _mapZoom = cameraPosition.zoom;
//   }

//   void makePlacemarksFromRoutes({
//     required List<Route> routes,
//     required Future<void> Function(Route route) onPlacemarkTap,
//   }) {
//     if (_placemarkObjects.length == routes.length) {
//       final newPlacemarks = _createPlacemarks(routes, onPlacemarkTap);
//       if (_arePlacemarksDifferent(_placemarkObjects, newPlacemarks)) {
//         l.s('Placemarks updated: ${newPlacemarks.length}');
//         _placemarkObjects = newPlacemarks;
//         _setStateCallback?.call();
//       }
//       return;
//     }

//     l.s('Placemarks created: ${routes.length}');

//     _placemarkObjects = _createPlacemarks(routes, onPlacemarkTap);
//     _makeClusterizedCollection();
//     _setStateCallback?.call();
//   }

//   Future<void> _showPointB(Route route) async {
//     final pointB = PlacemarkMapObject(
//       mapId: MapObjectId('Route #${route.id} B'),
//       point: Point(
//         latitude: route.latitudeB,
//         longitude: route.longitudeB,
//       ),
//       opacity: 1,
//       icon: PlacemarkIcon.single(
//         PlacemarkIconStyle(
//           image: BitmapDescriptor.fromAssetImage(
//             route.isMine
//                 ? Assets.images.imMyLocationOutlined.path
//                 : Assets.images.imLocationOutlinedB.path,
//           ),
//         ),
//       ),
//     );

//     // Убедитесь, что точка B не была добавлена ранее
//     if (!_placemarkObjects.any((p) => p.mapId == pointB.mapId)) {
//       _placemarkObjects.add(pointB);
//       _setStateCallback?.call();
//     }
//   }

//   // void makePlacemarksFromRoutes({
//   //   required List<Route> routes,
//   //   required Future<void> Function(Route route) onPlacemarkTap,
//   // }) {
//   //   //if (_placemarkObjects.isEmpty || _placemarkObjects.length != routes.length) return;
//   //   /// Сравнение по количеству маршрутов чтобы работало обновление маршрутов
//   //   if (_placemarkObjects.length == routes.length) return;

//   //   final placemarksA = routes
//   //       .map(
//   //         (route) => PlacemarkMapObject(
//   //           mapId: MapObjectId('Route #${route.id}'),
//   //           point: Point(
//   //             latitude: route.latitudeA,
//   //             longitude: route.longitudeA,
//   //           ),
//   //           opacity: 1,
//   //           icon: PlacemarkIcon.single(
//   //             PlacemarkIconStyle(
//   //               image: BitmapDescriptor.fromAssetImage(
//   //                 (route.isMine
//   //                         ? Assets.images.imMyLocationOutlined
//   //                         : Assets.images.imLocationOutlined)
//   //                     .path,
//   //               ),
//   //             ),
//   //           ),
//   //           onTap: (placemarkObject, __) {
//   //             onPlacemarkTap(route).then((_) async {
//   //               _repaintPlacemarks(isPlacemarkSelected: false);

//   //               _selectedObject = null;
//   //             });
//   //             _zoomPlacemark(placemarkObject);
//   //           },
//   //         ),
//   //       )
//   //       .toList();

//   //   final placemarksB = routes
//   //       .map(
//   //         (route) => PlacemarkMapObject(
//   //           mapId: MapObjectId('Route #${route.id} B'),
//   //           point: Point(
//   //             latitude: route.latitudeB,
//   //             longitude: route.longitudeB,
//   //           ),
//   //           opacity: 1,
//   //           icon: PlacemarkIcon.single(
//   //             PlacemarkIconStyle(
//   //               image: BitmapDescriptor.fromAssetImage(
//   //                 (route.isMine
//   //                         ? Assets.images.imMyLocationOutlined
//   //                         : Assets.images.imLocationOutlinedB)
//   //                     .path,
//   //               ),
//   //             ),
//   //           ),
//   //           onTap: (placemarkObject, __) {
//   //             onPlacemarkTap(route).then((_) async {
//   //               _repaintPlacemarks(isPlacemarkSelected: false);
//   //               _selectedObject = null;
//   //             });
//   //             _zoomPlacemark(placemarkObject);
//   //           },
//   //         ),
//   //       )
//   //       .toList();

//   //   _placemarkObjects = placemarksA + placemarksB;

//   //   _makeClusterizedCollection();
//   //   _setStateCallback?.call();
//   // }

//   Future<void> _zoomPlacemark(PlacemarkMapObject placemarkObject) async {
//     await mapController.moveCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: Point(
//             latitude: placemarkObject.point.latitude - 0.0005,
//             longitude: placemarkObject.point.longitude,
//           ),
//           zoom: 18,
//         ),
//       ),
//       animation: const MapAnimation(duration: 0.5),
//     );

//     if (placemarkObject == _selectedObject) return;
//     if (_selectedObject != null) {
//       _repaintPlacemarks(isPlacemarkSelected: false);
//     }
//     _selectedObject = placemarkObject;
//     _repaintPlacemarks(isPlacemarkSelected: true);
//   }

//   void _repaintPlacemarks({required bool isPlacemarkSelected}) {
//     final index = _placemarkObjects.indexWhere(
//       (obj) => obj.mapId == _selectedObject!.mapId,
//     );
//     final stringIcon = _selectedObject!.icon!.toString();
//     final isMyRoute = stringIcon.contains('imMyLocation');
//     //print(stringIcon);
//     final newImage = isPlacemarkSelected
//         ? (isMyRoute ? Assets.images.imMyLocation : Assets.images.imLocation)
//             .path
//         : (isMyRoute
//                 ? Assets.images.imMyLocationOutlined
//                 : Assets.images.imLocationOutlined)
//             .path;

//     _placemarkObjects[index] = _selectedObject!.copyWith(
//       icon: PlacemarkIcon.single(
//         PlacemarkIconStyle(
//           image: BitmapDescriptor.fromAssetImage(newImage),
//           scale: isPlacemarkSelected ? _selectedIconScale : _iconScale,
//         ),
//       ),
//     );
//     l.s(_placemarkObjects[index].icon?.toJson() ?? '');
//     _setStateCallback?.call();
//   }

//   ClusterizedPlacemarkCollection _makeClusterizedCollection() {
//     return ClusterizedPlacemarkCollection(
//       mapId: const MapObjectId('clusterized-1'),
//       placemarks: _placemarkObjects,
//       radius: 50,
//       minZoom: 15,
//       onClusterAdded: (self, cluster) async {
//         return cluster.copyWith(
//           appearance: cluster.appearance.copyWith(
//             opacity: 1,
//             icon: PlacemarkIcon.single(
//               PlacemarkIconStyle(
//                 image: BitmapDescriptor.fromBytes(
//                   await ClusterIconPainter(cluster.size).getClusterIconBytes(),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       onClusterTap: (self, cluster) async {
//         await mapController.moveCamera(
//           animation: const MapAnimation(
//             duration: 0.3,
//           ),
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: cluster.placemarks.first.point,
//               zoom: _mapZoom + 3,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
