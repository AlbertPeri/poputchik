import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/loaded_info/places_block/places_block.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/loaded_info/route_data_block/route_data_block.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter/material.dart' hide Route;

class LoadedInfo extends StatelessWidget {
  const LoadedInfo({
    required this.user,
    required this.route,
    super.key,
  });

  final User user;
  final Route route;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlacesBlock(route: route),
        const SizedBox(height: 14),
        RouteDataBlock(route: route, user: user),
        const SizedBox(height: 10),
      ],
    );
  }
}
