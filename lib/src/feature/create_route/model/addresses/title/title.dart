import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

part 'title.freezed.dart';
part 'title.g.dart';

@freezed
class Title with _$Title {
  const factory Title({
    required String text,
  }) = _Title;

  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json);

  factory Title.fromResponse(TitleResponse response) {
    return Title(
      text: response.text,
    );
  }
}
