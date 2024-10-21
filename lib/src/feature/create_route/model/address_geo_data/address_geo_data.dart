import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

part 'address_geo_data.freezed.dart';

@freezed
class AddressGeoData with _$AddressGeoData {
  const factory AddressGeoData({
    String? address,
    Point? point,
  }) = _AddresssesSuggest;
}
