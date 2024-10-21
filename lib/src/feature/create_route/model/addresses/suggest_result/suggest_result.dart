import 'package:companion/src/feature/create_route/model/addresses/address/address.dart';
import 'package:companion/src/feature/create_route/model/addresses/distance/distance.dart';
import 'package:companion/src/feature/create_route/model/addresses/title/title.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'suggest_result.freezed.dart';
part 'suggest_result.g.dart';

@freezed
class SuggestResult with _$SuggestResult {
  const factory SuggestResult({
    required List<String> tags,
    required Distance distance,
    Title? title,
    Title? subtitle,
    Address? address,
  }) = _SuggestResult;

  factory SuggestResult.fromJson(Map<String, dynamic> json) =>
      _$SuggestResultFromJson(json);

  factory SuggestResult.fromResponse(SuggestResultResponse response) {
    return SuggestResult(
      tags: response.tags,
      distance: Distance.fromResponse(response.distance),
      title:
          response.title != null ? Title.fromResponse(response.title!) : null,
      subtitle: response.subtitle != null
          ? Title.fromResponse(response.subtitle!)
          : null,
      address: response.address != null
          ? Address.fromResponse(response.address!)
          : null,
    );
  }
}
