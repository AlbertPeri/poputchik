import 'package:companion/src/core/widget/skeleton.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// AppButton widget
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton({
    required this.text,
    required this.height,
    required this.width,
    required this.onPressed,
    super.key,
    this.borderRadius = 35,
    this.isLoading = false,
  });

  final String text;

  final double height;

  final double width;

  final VoidCallback onPressed;

  final double borderRadius;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: WidgetShimmer(
          isLoading: isLoading,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito',
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
