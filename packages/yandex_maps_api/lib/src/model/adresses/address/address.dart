import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/src/model/model.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class AddressResponse with _$AddressResponse {
  const factory AddressResponse({
    @JsonKey(name: 'formatted_address') required String formattedAddress,
    List<ComponentResponse>? component,
  }) = _AddressResponse;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);
}
