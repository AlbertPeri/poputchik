import 'package:freezed_annotation/freezed_annotation.dart';

part 'distance.freezed.dart';
part 'distance.g.dart';

@freezed
class DistanceResponse with _$DistanceResponse {
  const factory DistanceResponse({
    required double value,
    required String text,
  }) = _DistanceResponse;

  factory DistanceResponse.fromJson(Map<String, dynamic> json) =>
      _$DistanceResponseFromJson(json);
}
