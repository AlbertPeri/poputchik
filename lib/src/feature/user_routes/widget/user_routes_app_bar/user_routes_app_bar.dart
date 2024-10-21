import 'package:companion/src/assets/typography/app_typography.dart';
import 'package:flutter/material.dart';

const _appBarHeight = 78.0;

class UserRoutesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UserRoutesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      scrolledUnderElevation: 0,
      // leading: const SizedBox(width: 20),
      // leadingWidth: 20,
      // titleSpacing: 0,
      toolbarHeight: _appBarHeight,
      title: Text(
        'Ваши поездки',
        style: AppTypography.sfPro30Medium,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);
}
