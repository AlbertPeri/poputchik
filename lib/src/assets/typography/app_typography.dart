import 'package:companion/gen/fonts.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:flutter/cupertino.dart';

/// Стили текстов
class AppTypography {
  AppTypography._();
  static const textLargeTitle32Bold = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 32,
    height: 1.125,
    fontWeight: FontWeight.w700,
  );

  static const textTitle24Bold = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  static const textSubtitle18Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w700,
  );

  static const textText16Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
  );

  static const textText16Regular = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w400,
  );

  static const textSmall14Bold = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w700,
  );

  static const textSmall14Regular = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w400,
  );

  static const textButton = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 14,
    height: 1.29,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w700,
  );

  static const textSuperSmall12Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
  );

  static const textSuperSmall12Regular = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
  );

  static const textDebugMedium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const textDebug = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w400,
  );

  /////

  static const nunito14Medium = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black2,
    height: 17.36 / 14,
  );

  static const nunito14Regular = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black2,
    height: 17.36 / 14,
  );

  static const sfPro12Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.black3,
    height: 21 / 12,
    letterSpacing: -0.32,
  );

  static const sfPro30Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlackColor,
    height: 39 / 30,
    letterSpacing: 0.5,
  );

  static const nunito20Medium = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 24.8 / 20,
  );

  static const nunito28SemiBold = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 34.72 / 28,
  );

  static const nunito22Medium = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 27.28 / 22,
  );

  static const nunito16Medium = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    height: 19.84 / 16,
  );

  static const sfPro17Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.black3,
    height: 22 / 17,
    letterSpacing: -0.4,
  );

  static const nunito10Regular = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.black3,
    height: 16 / 10,
  );

  static const nunito12Regular = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 16 / 12,
  );

  static const sfPro17Bold = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.black4,
    height: 19.09 / 17,
  );

  static const nunito8SemiBold = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 8,
    fontWeight: FontWeight.w600,
    color: AppColors.grey2,
    height: 10.91 / 8,
  );

  static const nunitoSans16Bold = TextStyle(
    fontFamily: FontFamily.nunitoSans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.black3,
    height: 28.64 / 16,
  );

  static const nunitoSans16Regular = TextStyle(
    fontFamily: FontFamily.nunitoSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black3,
    height: 28.64 / 16,
  );

  static const nunito12Medium = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.black3,
    height: 21 / 12,
    letterSpacing: -0.32,
  );

  static const nunitoSans14Bold = TextStyle(
    fontFamily: FontFamily.nunitoSans,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.black3,
    height: 25.06 / 14,
  );

  static const nunito50ExtraBold = TextStyle(
    fontFamily: FontFamily.nunito,
    fontSize: 50,
    fontWeight: FontWeight.w800,
    color: AppColors.black3,
  );

  static const sfPro20Medium = TextStyle(
    fontFamily: FontFamily.sofiaPro,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 24.8 / 20,
  );
}
