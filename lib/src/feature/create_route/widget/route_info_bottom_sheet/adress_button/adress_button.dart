import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:flutter/cupertino.dart';

class AdressButton extends StatelessWidget {
  const AdressButton({
    required this.title,
    required this.adressType,
    required this.adressModal,
    required this.isLoaded,
    super.key,
  });

  final String title;
  final bool isLoaded;
  final AdressType adressType;
  final void Function(BuildContext, AdressType) adressModal;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      color: AppColors.white,
      borderRadius: 24,
      overlayColor: AppColors.blackOverlay,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 21.5),
      child: Row(
        children: [
          Assets.icons.icPathCircle.svg(width: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              style: AppTypography.nunito14Regular.copyWith(
                color: isLoaded ? null : AppColors.textGreyColor,
              ),
            ),
          ),
        ],
      ),
      onTap: () => adressModal(context, adressType),
    );
  }
}
