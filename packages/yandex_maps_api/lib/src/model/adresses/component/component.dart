import 'package:freezed_annotation/freezed_annotation.dart';

part 'component.freezed.dart';
part 'component.g.dart';

@freezed
class ComponentResponse with _$ComponentResponse {
  const factory ComponentResponse({
    required String name,
    required List<String> kind,
  }) = _ComponentResponse;

  factory ComponentResponse.fromJson(Map<String, dynamic> json) =>
      _$ComponentResponseFromJson(json);
}
