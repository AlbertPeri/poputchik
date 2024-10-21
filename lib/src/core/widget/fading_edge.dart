import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';

/// {@template fading_edge}
/// Исчезающий край при скроле
/// {@endtemplate}
class FadingEdge extends StatelessWidget {
  /// {@macro fading_edge}
  const FadingEdge({
    required this.child, super.key,
    this.color,
    this.direction = Axis.vertical,
  });

  final Widget child;

  final Color? color;

  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final canvas = context.theme.cardColor;
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: direction == Axis.vertical
              ? Alignment.topCenter
              : Alignment.centerLeft,
          end: direction == Axis.vertical
              ? Alignment.bottomCenter
              : Alignment.centerRight,
          colors: [
            color ?? canvas,
            color ?? canvas,
            Colors.transparent,
            Colors.transparent,
          ],
          stops: const [0.0, 0.0, 0.01, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
