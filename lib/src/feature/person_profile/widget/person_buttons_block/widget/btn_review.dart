import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class BtnReview extends StatelessWidget {
  const BtnReview({
    required this.text,
    required this.onTap,
    required this.color,
    super.key,
  });

  final String text;

  final Color color;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTypography.nunito14Regular.copyWith(
                color: color == Colors.white ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
