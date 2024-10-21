import 'package:companion/src/feature/create_route/model/addresses/component/component.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    @JsonKey(name: 'formatted_address') required String formattedAddress,
    List<Component>? component,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  factory Address.fromResponse(AddressResponse response) {
    return Address(
      formattedAddress: response.formattedAddress,
      component: response.component?.map(Component.fromResponse).toList(),
    );
  }
}
