import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/cupertino.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({
    required this.onTap,
    required this.icon,
    super.key,
  });

  final void Function() onTap;

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 70,
      child: RoundedButton(
        borderRadius: 44,
        padding: const EdgeInsets.all(24),
        color: AppColors.white,
        overlayColor: AppColors.blackOverlay,
        onTap: onTap,
        child: icon,
      ),
    );
  }
}
