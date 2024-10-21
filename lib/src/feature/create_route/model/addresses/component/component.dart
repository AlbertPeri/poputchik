import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'component.freezed.dart';
part 'component.g.dart';

@freezed
class Component with _$Component {
  const factory Component({
    required String name,
    required List<String> kind,
  }) = _Component;

  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);

  factory Component.fromResponse(ComponentResponse response) {
    return Component(
      name: response.name,
      kind: response.kind,
    );
  }
}
