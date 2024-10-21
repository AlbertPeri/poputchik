import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _toolbarHeight = 70.0;

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceMaterialTransparency: true,
      toolbarHeight: _toolbarHeight,
      floating: true,
      titleSpacing: 20,
      title: const Text(
        'Профиль',
        style: AppTypography.sfPro30Medium,
      ),
      actions: [
        InkButton(
          padding: const EdgeInsets.fromLTRB(25, 23, 21, 23),
          onTap: () => showExitDialog(context),
          child: Assets.icons.icLogout.svg(),
        ),
        const Padding(padding: EdgeInsets.only(right: 20)),
      ],
    );
  }

  void showExitDialog(BuildContext context) => AppDialog.showCustomDialog(
        context,
        title: 'Вы действительно хотите выйти из аккаунта?',
        actionTitle: 'Выйти',
        onActionTap: () {
          context.pop();
          AuthScope.logOut(context);
          context.goNamed(RouteNames.myProfile);
        },
      );

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);
}
