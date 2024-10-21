import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion_api/companion.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_routes.freezed.dart';
part 'all_routes.g.dart';

@freezed
class AllRoutes with _$AllRoutes {
  const factory AllRoutes({
    @JsonKey(name: 'data') required List<Route> routes,
  }) = _AllRoutes;

  factory AllRoutes.fromJson(Map<String, dynamic> json) =>
      _$AllRoutesFromJson(json);

  factory AllRoutes.fromResponse(AllRoutesResponse response) {
    return AllRoutes(
      routes: response.routes.map(Route.fromResponse).toList(),
    );
  }
}
