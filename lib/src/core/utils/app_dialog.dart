import 'package:companion/src/assets/colors/app_colors.dart';
import 'package:companion/src/assets/typography/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Диалоговые окна приложения
mixin AppDialog {
  /// Копировать в буфер обмена
  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Скопировано'),
        ),
      ),
    );
  }

  /// Показывает нижний SnackBar
  static void showSnackbar(BuildContext context, String text) =>
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior.floating,
          ),
        );

  static Future<void> showCustomDialog(
    BuildContext context, {
    required String title,
    required String actionTitle,
    required void Function() onActionTap,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        final textStyle = AppTypography.nunito16Medium.copyWith(
          color: AppColors.black,
        );

        return AlertDialog.adaptive(
          backgroundColor: AppColors.white,
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 20),
          title: Text(
            title,
            style:
                AppTypography.nunito20Medium.copyWith(color: AppColors.black4),
          ),
          actions: [
            TextButton(
              onPressed: onActionTap,
              child: Text(actionTitle, style: textStyle),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Отмена', style: textStyle),
            ),
          ],
        );
      },
    );
  }
}
