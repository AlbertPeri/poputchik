import 'dart:io';

import 'package:companion/src/assets/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// {@template loader}
///  Индикатор загрузки
/// {@endtemplate}
class Loader extends StatelessWidget {
  /// {@macro loader}
  const Loader({super.key, this.color, this.dimension});

  final Color? color;

  final double? dimension;

  @override
  Widget build(BuildContext context) => Center(
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                color: color ?? AppColors.black,
              )
            : SizedBox.square(
                dimension: dimension,
                child: CircularProgressIndicator(
                  color: color ?? AppColors.black,
                  strokeWidth: 2,
                ),
              ),
      );
}
