import 'package:companion/src/config/app_config.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/data/adresses_exception.dart';
import 'package:companion/src/feature/create_route/model/addresses/addresses_suggest/addresses_suggest.dart';
import 'package:dio/dio.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart' as gc hide Point;
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart' show Point;
import 'package:yandex_maps_api/yandex_maps.dart';

abstract interface class IAdressesRepository {
  Future<AddressesSuggest> getAdresses({required String query});
  Future<String> geocodeFromPoint({required Point point});
  Future<Point> geocodeFromAdress({required String adress});
}

final class AdressesRepository implements IAdressesRepository {
  const AdressesRepository({
    required gc.YandexGeocoder yandexGeocoder,
    required YandexMapsClient yandexMapsClient,
  })  : _yandexGeocoder = yandexGeocoder,
        _yandexMapsClient = yandexMapsClient;

  final gc.YandexGeocoder _yandexGeocoder;
  final YandexMapsClient _yandexMapsClient;

  @override
  Future<Point> geocodeFromAdress({required String adress}) async {
    try {
      final geocodeResponse = await _yandexGeocoder.getGeocode(
        gc.DirectGeocodeRequest(
          addressGeocode: adress,
          lang: gc.Lang.ru,
        ),
      );
      final point = geocodeResponse.firstPoint!;
      return Point(latitude: point.lat, longitude: point.lon);
    } on gc.Error catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AdressesException(error.message),
        stackTrace,
      );
    }
  }

  @override
  Future<String> geocodeFromPoint({required Point point}) async {
    try {
      final geocodeResponse = await _yandexGeocoder.getGeocode(
        gc.ReverseGeocodeRequest(
          pointGeocode: (lat: point.latitude, lon: point.longitude),
          lang: gc.Lang.ru,
        ),
      );
      var adress = geocodeResponse.firstFullAddress.formattedAddress ?? '';
      if (adress.startsWith('Россия,')) {
        adress = adress.replaceFirst('Россия,', '');
      }
      return adress.trim();
    } on gc.Error catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AdressesException(error.message),
        stackTrace,
      );
    }
  }

  @override
  Future<AddressesSuggest> getAdresses({required String query}) async {
    try {
      final response = await _yandexMapsClient.getAddresses(
        query: query,
        apiKey: AppConfig.geosadgestApiKey,
      );
      return AddressesSuggest.fromResponse(response);
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const AdressesException(),
        errorBuilder: AdressesException.new,
      );
    }
  }
}
