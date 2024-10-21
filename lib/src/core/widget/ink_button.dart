import 'package:flutter/material.dart';

class InkButton extends StatelessWidget {
  const InkButton({
    required this.child,
    this.onTap,
    this.color,
    this.borderRadius,
    this.splashColor,
    this.padding,
    super.key,
  });

  final void Function()? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brdRadius = borderRadius ?? BorderRadius.circular(44);

    return Material(
      color: color ?? Colors.white,
      borderRadius: brdRadius,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? Colors.black.withOpacity(0.1),
        borderRadius: brdRadius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: brdRadius,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
