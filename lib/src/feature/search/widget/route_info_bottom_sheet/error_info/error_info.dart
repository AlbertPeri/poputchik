import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/scope/route_info_scope.dart';
import 'package:flutter/material.dart';

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          children: [
            Text(message),
            const SizedBox(height: 14),
            RoundedButton(
              color: AppColors.black,
              overlayColor: AppColors.whiteOverlay,
              child: Text(
                'Повторить',
                style: AppTypography.nunito14Regular.copyWith(
                  color: AppColors.white,
                ),
              ),
              onTap: () => _onTap(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    RouteInfoScope.getUserInfo(context, null);
  }
}
