import 'dart:typed_data';
import 'dart:ui';

import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class ClusterIconPainter {
  const ClusterIconPainter(this.clusterSize);

  final int clusterSize;

  Future<Uint8List> getClusterIconBytes() async {
    const size = Size(150, 150);
    final recorder = PictureRecorder();

    // отрисовка маркера
    _paintTextCountPlacemarks(
      text: clusterSize.toString(),
      size: size,
      canvas: _paintCirclePlacemark(
        size: size,
        recorder: recorder,
      ),
    );

    // преобразование в байтовый формат
    final image = await recorder.endRecording().toImage(
          size.width.toInt(),
          size.height.toInt(),
        );
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  /// Метод, который отрисовывает фигуру кластера (фон и обводка)
  Canvas _paintCirclePlacemark({
    required Size size,
    required PictureRecorder recorder,
  }) {
    final canvas = Canvas(recorder);

    final radius = size.height / 3;

    // внутренний круг - закрашенная часть маркера
    final fillPaint = Paint()
      ..color = AppColors.backgroundColor
      ..style = PaintingStyle.fill;

    // внешний круг - обводка маркера
    final strokePaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas
      ..drawCircle(circleOffset, radius, fillPaint)
      ..drawCircle(circleOffset, radius, strokePaint);
    return canvas;
  }

  /// Метод, который отрисовывает текст,
  /// отображающий количество маркеров в кластере
  void _paintTextCountPlacemarks({
    required String text,
    required Size size,
    required Canvas canvas,
  }) {
    // внешний вид текста, отображающего количество маркеров в кластере
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTypography.nunito50ExtraBold,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    // смещение текста
    // необходимо для размещения текста по центру кластера
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }
}
