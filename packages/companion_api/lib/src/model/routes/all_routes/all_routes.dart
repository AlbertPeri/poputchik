import 'package:companion_api/companion.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_routes.freezed.dart';
part 'all_routes.g.dart';

@freezed
class AllRoutesResponse with _$AllRoutesResponse {
  const factory AllRoutesResponse({
    @JsonKey(name: 'data') required List<RouteResponse> routes,
  }) = _AllRoutesResponse;

  factory AllRoutesResponse.fromJson(Map<String, dynamic> json) =>
      _$AllRoutesResponseFromJson(json);
}
