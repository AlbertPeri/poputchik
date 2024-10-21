import 'package:companion/src/feature/create_route/model/addresses/suggest_result/suggest_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'addresses_suggest.freezed.dart';
part 'addresses_suggest.g.dart';

@freezed
class AddressesSuggest with _$AddressesSuggest {
  const factory AddressesSuggest({
    @JsonKey(name: 'suggest_reqid') required String suggestReqid,
    List<SuggestResult>? results,
  }) = _AddressesSuggest;

  factory AddressesSuggest.fromJson(Map<String, dynamic> json) =>
      _$AddressesSuggestFromJson(json);

  factory AddressesSuggest.fromResponse(AddressesSuggestResponse response) {
    return AddressesSuggest(
      suggestReqid: response.suggestReqid,
      results: response.results?.map(SuggestResult.fromResponse).toList(),
    );
  }
}
