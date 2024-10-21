import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/src/model/model.dart';

part 'suggest_result.freezed.dart';
part 'suggest_result.g.dart';

@freezed
class SuggestResultResponse with _$SuggestResultResponse {
  const factory SuggestResultResponse({
    required List<String> tags,
    required DistanceResponse distance,
    TitleResponse? title,
    TitleResponse? subtitle,
    AddressResponse? address,
  }) = _SuggestResultResponse;

  factory SuggestResultResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestResultResponseFromJson(json);
}
