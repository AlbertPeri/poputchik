import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'distance.freezed.dart';
part 'distance.g.dart';

@freezed
class Distance with _$Distance {
  const factory Distance({
    required double value,
    required String text,
  }) = _Distance;

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);

  factory Distance.fromResponse(DistanceResponse response) {
    return Distance(
      value: response.value,
      text: response.text,
    );
  }
}
