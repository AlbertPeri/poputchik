import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/scope/search_scope.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:companion_api/companion.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';

class TopButtonsRow extends StatelessWidget {
  const TopButtonsRow({
    required this.route,
    super.key,
  });

  final Route route;

  @override
  Widget build(BuildContext context) {
    final status = route.status ?? RouteStatus.waiting;

    return Row(
      children: [
        RoundedButton(
          height: 45,
          width: 45,
          child: Assets.icons.icDelete.svg(
            colorFilter:
                const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
          ),
          onTap: () => _onDeleteTap(context),
        ),
        const SizedBox(width: 8),
        RoundedButton(
          height: 45,
          color: switch (status) {
            RouteStatus.waiting => AppColors.darkBlueColor2,
            RouteStatus.accepted => AppColors.darkBlueColor2,
            RouteStatus.completed => AppColors.darkBlueColor2.withOpacity(0.3),
          },
          borderRadius: 55,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            status.text,
            style: AppTypography.nunito14Regular.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        const Spacer(),
        if (status == RouteStatus.waiting)
          IconButton(
            onPressed: () => _onEditRouteTap(context),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Assets.icons.icEdit.svg(
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onEditRouteTap(BuildContext context) async {
    final result = await context.pushNamed(
      RouteNames.createRoute,
      extra: {'routeToEdit': route},
    );
    if (result is String && result == 'update' && context.mounted) {
      UserRoutesScope.getRoutes(context);
      SearchScope.getAllRoutes(context);
    }
  }

  Future<void> _onDeleteTap(BuildContext context) => AppDialog.showCustomDialog(
        context,
        title: 'Вы действительно хотите удалить поездку?',
        actionTitle: 'Удалить',
        onActionTap: () {
          UserRoutesScope.deleteRoute(context, route.id);
          context.pop();
        },
      );
}
