import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String goToMapPopValue = 'go_to_map';

class AdressTextField extends StatelessWidget {
  const AdressTextField({
    required this.controller,
    required this.adressType,
    required this.onChanged,
    required this.showMapButton,
    super.key,
  });

  final TextEditingController controller;
  final AdressType adressType;
  final void Function(String) onChanged;
  final bool showMapButton;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTypography.nunito14Regular.copyWith(
        color: AppColors.textBlackColor,
      ),
      enableSuggestions: false,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: switch (adressType) {
          AdressType.departure => 'Откуда поедете?',
          AdressType.arrival => 'Куда поедете?',
        },
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 4),
          child: Assets.icons.icSearchSmall.svg(),
        ),
        isCollapsed: true,
        isDense: true,
        prefixIconConstraints: const BoxConstraints(
          maxHeight: 13,
          maxWidth: 27,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                child: IconButton(
                  onPressed: controller.clear,
                  padding: EdgeInsets.zero,
                  icon: Assets.icons.icClose.svg(),
                ),
              ),
              if (showMapButton) ...[
                const VerticalDivider(width: 1),
                TextButton(
                  onPressed: () => context.pop(goToMapPopValue),
                  child: Text(
                    'Карта',
                    style: AppTypography.nunito14Regular.copyWith(
                      color: AppColors.textGreyColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 33,
        ),
      ),
    );
  }
}
