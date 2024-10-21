import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 4;
    const dashSpace = 3;
    var startY = 0.0;

    final paint = Paint()
      ..color = AppColors.dashColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
