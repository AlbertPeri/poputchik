import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpacityAndPositionedBulder extends StatelessWidget {
  const OpacityAndPositionedBulder({
    required this.valueListenable,
    required this.child,
    super.key,
    this.addPositionedListenable = false,
    this.bottomPadding = 0.0,
  });

  final ValueListenable<bool> valueListenable;
  final Widget child;
  final bool addPositionedListenable;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (context, hide, child) {
        if (addPositionedListenable) {
          return AnimatedPositioned(
            right: 20,
            bottom: 10 + bottomPadding,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: AnimatedOpacity(
              opacity: hide ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: child,
            ),
          );
        }
        return AnimatedOpacity(
          opacity: hide ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          child: child,
        );
      },
      child: child,
    );
  }
}
