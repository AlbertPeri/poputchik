// ignore_for_file: one_member_abstracts

import 'package:geolocator/geolocator.dart';
import 'package:l/l.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';

abstract interface class ILocationService {
  Future<bool> checkStatus();
}

final class LocationService implements ILocationService {
  const LocationService();

  @override
  Future<bool> checkStatus() async {
    final locationInUsePermissionIsGranted =
        await Permission.locationWhenInUse.isGranted;
    //final locationAlwaysPermissionIsGranted =
    // await Permission.locationAlways.isGranted;
    final permissionStatus = await Geolocator.checkPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    l
      ..d('permisson status - $permissionStatus')
      ..d('service enabled - $serviceEnabled')
      //..d('always location enabled - $locationAlwaysPermissionIsGranted')
      ..d('in use location enabled - $locationInUsePermissionIsGranted')
      ..d('-------------');
    if (permissionStatus != LocationPermission.denied &&
        serviceEnabled &&
        locationInUsePermissionIsGranted) {
      l.d('all geo permissions and geoservice enabled');
      return true;
    } else {
      if (!locationInUsePermissionIsGranted) {
        final inUseEnabled = await _requestInUse();
        l.d('inUseEnabled - $inUseEnabled');
        if (!inUseEnabled) return false;
      }
      // if (!locationAlwaysPermissionIsGranted) {
      //   final alwaysEnabled = await _requestAlways();
      //   l.d('alwaysEnabled - $alwaysEnabled');
      //   if (!alwaysEnabled) return false;
      // }
      if ([LocationPermission.denied, LocationPermission.deniedForever]
          .contains(permissionStatus)) {
        final locationStatus = await _requestLocation();
        l.d('locationStatus - $locationStatus');
        if (locationStatus == LocationPermission.denied) return false;
      }
      if (!serviceEnabled) {
        final newServiceEnabled = await _requestService();
        l.d('newServiceEnabled - $newServiceEnabled');
        if (!newServiceEnabled) return false;
      }
      l.d('all enabled!');
      return true;
    }
  }

  Future<bool> _requestInUse() =>
      Permission.locationWhenInUse.request().isGranted;

  // Future<bool> _requestAlways() =>
  // Permission.locationAlways.request().isGranted;

  Future<LocationPermission> _requestLocation() =>
      Geolocator.requestPermission();

  Future<bool> _requestService() => Location().requestService();
}
