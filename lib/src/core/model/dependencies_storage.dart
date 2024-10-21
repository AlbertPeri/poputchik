import 'package:companion/src/config/app_config.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

abstract class IDependenciesStorage {
  Dio get dio;
  AppDatabase get database;
  SharedPreferences get sharedPreferences;
  FlutterSecureStorage get secureStorage;
  CompanionClient get companionClient;
  YandexMapsClient get yandexMapsClient;
  YandexGeocoder get yandexGeocoder;
  IToastService get toastService;
  ILocationService get locationService;

  void close();
}

class DependenciesStorage implements IDependenciesStorage {
  DependenciesStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  Dio? _dio;

  AppDatabase? _database;

  @override
  Dio get dio => _dio ??= Dio();

  @override
  AppDatabase get database => _database ??= AppDatabase(name: AppConfig.dbName);

  @override
  SharedPreferences get sharedPreferences => _sharedPreferences;

  @override
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @override
  Future<void> close() async {
    _dio?.close();
    await _database?.close();
  }

  @override
  CompanionClient get companionClient => CompanionClient(dio);

  @override
  YandexMapsClient get yandexMapsClient => YandexMapsClient(dio);

  @override
  YandexGeocoder get yandexGeocoder =>
      YandexGeocoder(apiKey: AppConfig.geocoderApiKey);

  @override
  IToastService get toastService => ToastService();

  @override
  ILocationService get locationService => const LocationService();
}
