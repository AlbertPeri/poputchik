import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';

/// {@template empty_placeholder}
///  Заглушка для пустых списков
/// {@endtemplate}
class EmptyPlaceholder extends StatelessWidget {
  /// {@macro empty_placeholder}
  const EmptyPlaceholder({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(kSidePadding),
          child: Text(
            message ?? context.localized.emptyText,
            style: AppTypography.sfPro20Medium
                .copyWith(height: 1.4, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
