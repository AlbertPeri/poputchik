import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// {@template skeleton}
/// Заглушка для загрузки
/// {@endtemplate}
class Skeleton extends StatelessWidget {
  /// {@macro skeleton}
  const Skeleton({
    required this.width,
    super.key,
    this.height = 16,
    this.borderRadius,
  });

  final double width;

  final double height;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 800),
      baseColor: context.theme.colorScheme.secondary.withOpacity(.03),
      highlightColor: context.theme.colorScheme.secondary.withOpacity(.1),
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// {@template skeleton}
/// Шиммер поверх виджета
/// {@endtemplate}
class WidgetShimmer extends StatelessWidget {
  /// {@macro skeleton}
  const WidgetShimmer({
    required this.child,
    required this.isLoading,
    super.key,
  });

  final Widget child;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            period: const Duration(milliseconds: 800),
            baseColor: AppColors.accentColor,
            highlightColor: Colors.white.withOpacity(.4),
            enabled: isLoading,
            child: child,
          )
        : child;
  }
}
