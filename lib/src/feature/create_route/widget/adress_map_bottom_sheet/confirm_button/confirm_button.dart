import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/cupertino.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    required this.onTap,
    super.key,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      color: AppColors.black,
      borderRadius: 35,
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 24.5),
      onTap: onTap,
      showDisabledColor: true,
      child: Text(
        'Подтвердить',
        style: AppTypography.nunito14Medium.copyWith(color: AppColors.white),
      ),
    );
  }
}
