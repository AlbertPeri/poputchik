import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/cupertino.dart';

class UpperActionButton extends StatelessWidget {
  const UpperActionButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onTap: onTap,
      color: AppColors.white,
      overlayColor: AppColors.black.withOpacity(0.15),
      borderRadius: 35,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: AppTypography.nunito16Medium.copyWith(
          color: AppColors.black3,
          height: 28.64 / 20,
        ),
      ),
    );
  }
}
