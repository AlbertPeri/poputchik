import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _appbarHeight = 70.0;

class PersonProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PersonProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _appbarHeight,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: InkButton(
          onTap: () => context.pop(),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          child: Assets.icons.icArrowBack.svg(
            height: 24,
          ),
        ),
      ),
      leadingWidth: 90,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appbarHeight);
}
