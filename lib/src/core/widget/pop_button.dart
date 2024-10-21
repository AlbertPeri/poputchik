import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopButton extends StatelessWidget {
  const PopButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 65,
      child: InkButton(
        onTap: onTap ?? () => context.pop(),
        // padding: const EdgeInsets.all(24),
        child: Center(
          child: Assets.icons.icArrowBack.svg(
            height: 18,
            width: 18,
          ),
        ),
      ),
    );
  }
}
