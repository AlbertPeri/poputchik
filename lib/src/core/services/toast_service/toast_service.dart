import 'package:companion/src/assets/colors/app_colors.dart';
import 'package:companion/src/assets/typography/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract interface class IToastService {
  void init(BuildContext context);
  void showError(String message);
  void showSuccess(String message);
}

final class ToastService implements IToastService {
  ToastService() {
    _toast = FToast();
  }

  @override
  void init(BuildContext context) {
    _toast.init(context);
  }

  late final FToast _toast;

  Color _getBackgroundColor(ToastType toastType) => switch (toastType) {
        ToastType.error => AppColors.errorToastBackground,
        ToastType.success => AppColors.successToastBackground,
      };

  Color _getTextColor(ToastType toastType) => switch (toastType) {
        ToastType.error => AppColors.errorToastText,
        ToastType.success => AppColors.successToastText,
      };

  IconData _getIcon(ToastType toastType) => switch (toastType) {
        ToastType.error => Icons.error_rounded,
        ToastType.success => Icons.check_circle_rounded,
      };

  @override
  void showError(String message) => _showToast(message, ToastType.error);

  @override
  void showSuccess(String message) => _showToast(message, ToastType.success);

  void _showToast(String message, ToastType toastType) {
    _toast
      ..removeCustomToast()
      ..showToast(
        child: _buildToastChild(message, toastType),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 20 + MediaQuery.of(context).padding.top,
            left: 20,
            right: 20,
            child: child,
          );
        },
      );
  }

  Widget _buildToastChild(String message, ToastType toastType) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: _getBackgroundColor(toastType),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon(toastType), size: 16, color: _getTextColor(toastType)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: AppTypography.nunito14Regular.copyWith(
                color: _getTextColor(toastType),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ToastType {
  error,
  success;
}
