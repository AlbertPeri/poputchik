import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/scope/search_scope.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRouteButton extends StatelessWidget {
  const CreateRouteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      width: double.infinity,
      color: AppColors.black,
      borderRadius: 37,
      padding: const EdgeInsets.symmetric(vertical: 21.5),
      child: Text(
        'Создать поездку',
        style: AppTypography.nunito14Medium.copyWith(
          color: AppColors.white,
        ),
      ),
      onTap: () => _onCreateRouteButtonTap(context),
    );
  }

  Future<void> _onCreateRouteButtonTap(BuildContext context) async {
    final result = await context.pushNamed(RouteNames.createRoute);
    if (result is String && result == 'update' && context.mounted) {
      UserRoutesScope.getRoutes(context);
      SearchScope.getAllRoutes(context);
    }
  }
}
