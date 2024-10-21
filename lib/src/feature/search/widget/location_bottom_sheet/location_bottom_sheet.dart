import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({super.key});

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      padding: const EdgeInsets.all(20).copyWith(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Мое\nместонахождение',
            style: AppTypography.nunito20Medium.copyWith(
              color: AppColors.textBlackColor,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            style: AppTypography.nunito14Regular,
            enableSuggestions: false,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 4),
                child: Assets.icons.icPathCircle.svg(),
              ),
              prefixIconConstraints: BoxConstraints.tight(const Size(30, 16)),
              hintText: 'Введите адрес',
            ),
          ),
        ],
      ),
    );
  }
}
