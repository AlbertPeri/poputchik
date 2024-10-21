import 'package:companion/gen/fonts.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';

/// {@template edit_item_profile}
/// EditItemProfile widget
/// {@endtemplate}
class EditItemProfile extends StatelessWidget {
  /// {@macro edit_item_profile}
  const EditItemProfile({
    required this.title,
    required this.controller,
    required this.onPressed,
    required this.hintText,
    required this.btnText,
    super.key,
  });

  final String title;

  final TextEditingController controller;

  final VoidCallback onPressed;

  final String hintText;

  final String btnText;

  @override
  Widget build(BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SizedBox(
          height: 245,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.sofiaPro,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  controller: controller,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: AppColors.textGreyColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: btnText,
                  height: 60,
                  width: double.infinity,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      );
}
