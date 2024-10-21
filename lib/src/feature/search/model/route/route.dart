import 'package:companion_api/companion.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class Route with _$Route {
  const factory Route({
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
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isMine,
  }) = _Route;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  factory Route.fromResponse(RouteResponse response) {
    return Route(
      id: response.id,
      name: response.name,
      description: response.description,
      date: response.date,
      peopleAmount: response.peopleAmount,
      startPlace: response.startPlace,
      endPlace: response.endPlace,
      latitudeA: response.latitudeA,
      longitudeA: response.longitudeA,
      latitudeB: response.latitudeB,
      longitudeB: response.longitudeB,
      usersId: response.usersId,
      status: response.status,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}
