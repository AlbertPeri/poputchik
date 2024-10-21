import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';

class LoadingInfo extends StatelessWidget {
  const LoadingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300,
      child: Center(child: Loader()),
    );
  }
}
