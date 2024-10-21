import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class RouteResponse with _$RouteResponse {
  const factory RouteResponse({
    required int id,
    required String? name,
    required String? description,
    required DateTime date,
    required int peopleAmount,
    required String startPlace,
    required String endPlace,
    required RouteStatus? status,
    @JsonKey(name: 'latitude_A') required double latitudeA,
    @JsonKey(name: 'longitude_A') required double longitudeA,
    @JsonKey(name: 'latitude_B') required double latitudeB,
    @JsonKey(name: 'longitude_B') required double longitudeB,
    required int usersId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RouteResponse;

  factory RouteResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseFromJson(json);
}

@JsonEnum(alwaysCreate: true)
enum RouteStatus {
  waiting('Активна'),
  accepted('Принята'),
  completed('Завершена');

  const RouteStatus(this.text);

  final String text;
}
