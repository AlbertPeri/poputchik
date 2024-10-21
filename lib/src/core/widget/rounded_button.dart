import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    this.color = AppColors.darkBlueColor2,
    this.borderRadius = 36,
    this.padding = const EdgeInsets.all(10.5),
    this.onTap,
    this.overlayColor,
    this.height,
    this.width,
    this.showDisabledColor = false,
    super.key,
  });

  final Widget child;
  final double? height;
  final double? width;
  final Color color;
  final Color? overlayColor;
  final double borderRadius;
  final EdgeInsets padding;
  final void Function()? onTap;
  final bool showDisabledColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith(
            (state) {
              if (!showDisabledColor) {
                return color;
              }
              if (state.contains(WidgetState.disabled)) {
                return AppColors.disabledButton;
              }
              return color;
            },
          ),
          overlayColor: WidgetStatePropertyAll(
            overlayColor ?? AppColors.whiteOverlay,
          ),
          padding: WidgetStatePropertyAll(padding),
          // backgroundColor: MaterialStatePropertyAll(
          //   color ?? AppColors.darkBlueColor2,
          // ),
        ),
        child: child,
      ),
    );
  }
}
