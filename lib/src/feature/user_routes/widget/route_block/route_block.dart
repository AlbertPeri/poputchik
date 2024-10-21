import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user_routes/widget/route_block/bottom_buttons_row/bottom_buttons_row.dart';
import 'package:companion/src/feature/user_routes/widget/route_block/route_data_row/route_data_row.dart';
import 'package:companion/src/feature/user_routes/widget/route_block/top_buttons_row/top_buttons_row.dart';
import 'package:flutter/material.dart' hide Route;

class RouteBlock extends StatelessWidget {
  const RouteBlock({
    required this.route,
    super.key,
  });

  final Route route;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TopButtonsRow(route: route),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: RouteDataRow(route: route),
          ),
          BottomButtonsRow(route: route),
        ],
      ),
    );
  }
}
