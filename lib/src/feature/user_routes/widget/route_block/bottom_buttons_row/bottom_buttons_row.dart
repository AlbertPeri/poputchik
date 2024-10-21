import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:companion_api/companion.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';

class BottomButtonsRow extends StatelessWidget {
  const BottomButtonsRow({
    required this.route,
    super.key,
  });

  final Route route;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        AppTypography.nunito14Medium.copyWith(color: AppColors.white);

    return Row(
      children: [
        if (route.status != RouteStatus.completed)
          //   Expanded(
          //     child: RoundedButton(
          //       height: 60,
          //       padding: const EdgeInsets.fromLTRB(5, 9, 26, 9),
          //       color: AppColors.black,
          //       child: Row(
          //         children: [
          //           RoundedButton(
          //             height: 42,
          //             width: 42,
          //             color: AppColors.white,
          //             padding: const EdgeInsets.symmetric(
          //               vertical: 12,
          //               horizontal: 11,
          //             ),
          //             borderRadius: 29,
          //             child: Assets.icons.icRetry.svg(),
          //           ),
          //           const Spacer(),
          //           Text('Повторить поездку', style: textStyle),
          //           const Spacer(),
          //         ],
          //       ),
          //       onTap: () {},
          //     ),
          //   )
          // else
          Expanded(
            child: RoundedButton(
              height: 60,
              color: AppColors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Завершить', style: textStyle),
              onTap: () => _onCompleteTap(context),
            ),
          ),
      ],
    );
  }

  Future<void> _onCompleteTap(BuildContext context) =>
      AppDialog.showCustomDialog(
        context,
        title: 'Вы действительно хотите завершить поездку?',
        actionTitle: 'Завершить',
        onActionTap: () {
          UserRoutesScope.completeRoute(context, route.id);
          context.pop();
        },
      );
}
