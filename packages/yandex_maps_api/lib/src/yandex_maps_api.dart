import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:yandex_maps_api/src/model/model.dart';

part 'yandex_maps_api.g.dart';

@RestApi(baseUrl: 'https://suggest-maps.yandex.ru/v1/')
abstract class YandexMapsClient {
  factory YandexMapsClient(
    Dio dio, {
    String? baseUrl,
  }) {
    return _YandexMapsClient(dio, baseUrl: baseUrl);
  }

  /// Получение списка адресов
  @GET('/suggest')
  Future<AddressesSuggestResponse> getAddresses({
    @Query('apikey', encoded: true) required String apiKey,
    @Query('text') required String query,
    @Query('results') int results = 5,
    @Query('print_address') int printAddress = 1,
    @Query('highlight') int highlight = 0,
    @Query('lang') String lang = 'ru',
  });
}
