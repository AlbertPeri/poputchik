import 'package:freezed_annotation/freezed_annotation.dart';

part 'title.freezed.dart';
part 'title.g.dart';

@freezed
class TitleResponse with _$TitleResponse {
  const factory TitleResponse({
    required String text,
  }) = _TitleResponse;

  factory TitleResponse.fromJson(Map<String, dynamic> json) =>
      _$TitleResponseFromJson(json);
}
