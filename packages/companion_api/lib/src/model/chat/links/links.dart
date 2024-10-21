import 'package:freezed_annotation/freezed_annotation.dart';

part 'links.freezed.dart';
part 'links.g.dart';

@freezed
class LinksResponse with _$LinksResponse {
  const factory LinksResponse({
    required String? url,
    required String label,
    required bool active,
  }) = _LinksResponse;

  factory LinksResponse.fromJson(Map<String, Object?> json) =>
      _$LinksResponseFromJson(json);
}
