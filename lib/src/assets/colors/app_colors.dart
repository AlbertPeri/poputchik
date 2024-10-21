import 'package:flutter/material.dart';

/// Цвета приложения
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black2 = Color(0xFF000104);
  static const Color black3 = Color(0xFF131925);
  static const Color black4 = Color(0xFF2F2C37);
  static const Color grey = Color(0xFFB6BEBB);
  static const Color grey2 = Color(0xFFA2A0AC);
  static const Color grey3 = Color(0xFFCFCFCF);

  static const Color backgroundColor = Color(0xFFEFF2FD);
  static const Color textGreyColor = Color(0xFF9EA3B3);
  static const Color textBlackColor = Color(0xFF161616);
  static const Color accentColor = Color(0xFFE5EAFD);
  static const Color blueColor = Color(0xFF3F79D6);
  static const Color blueColor2 = Color(0xFF93A9FE);
  static const Color darkBlueColor = Color(0xFFB2C3FD);
  static const Color darkBlueColor2 = Color(0xFFDBE2FD);
  static const Color darkPurple = Color(0xFF4B508B);
  static const Color iconColor = Color(0xFFB7B9BD);

  static const Color errorToastBackground = Color(0xFFFFE2E2);
  static const Color errorToastText = Color(0xFFFF2418);
  static const Color successToastBackground = Color(0xFFE3FFDC);
  static const Color successToastText = Color(0xFF0A5E07);

  static final Color blackOverlay = AppColors.black.withOpacity(0.075);
  static final Color whiteOverlay = AppColors.white.withOpacity(0.1);
  static final Color barrierColor = Colors.transparent.withOpacity(0.2);
  static final Color disabledButton = AppColors.black.withOpacity(0.1);

  static const Color dashColor = Color.fromRGBO(15, 19, 33, 0.3);
}
