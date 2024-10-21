import 'package:companion/src/assets/typography/app_typography.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user_routes/widget/route_block/route_block.dart';
import 'package:flutter/material.dart' hide Route;

const _buttonHeight = 60.0;

class LoadedRoutes extends StatefulWidget {
  const LoadedRoutes({
    required this.routes,
    super.key,
  });

  final List<Route> routes;

  @override
  State<LoadedRoutes> createState() => _LoadedRoutesState();
}

class _LoadedRoutesState extends State<LoadedRoutes> {
  late final List<Route> routes = widget.routes.reversed.toList();

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) {
      return Text(
        AuthScope.isAuthOf(context, listen: true)
            ? 'У вас еще нет поездок.\nСоздайте поездку'
            : 'Для создания поездки необходимо авторизоваться',
        style: AppTypography.sfPro20Medium
            .copyWith(height: 1.4, color: Colors.grey),
        textAlign: TextAlign.center,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemCount: routes.length + 1,
      itemBuilder: (context, index) {
        if (index == routes.length) {
          return const SizedBox(height: _buttonHeight);
        }
        return RouteBlock(route: routes[index]);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 20),
    );
  }
}
