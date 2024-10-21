import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/src/model/model.dart';

part 'addresses_suggest.freezed.dart';
part 'addresses_suggest.g.dart';

@freezed
class AddressesSuggestResponse with _$AddressesSuggestResponse {
  const factory AddressesSuggestResponse({
    @JsonKey(name: 'suggest_reqid') required String suggestReqid,
    List<SuggestResultResponse>? results,
  }) = _AddressesSuggestResponse;

  factory AddressesSuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressesSuggestResponseFromJson(json);
}
