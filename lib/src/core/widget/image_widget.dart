import 'package:cached_network_image/cached_network_image.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';

//// {@template image_widget}
/// Виджет для отображения изображения по ссылке
class ImageWidget extends StatelessWidget {
  /// {@macro image_widget}
  const ImageWidget({
    this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorWidget,
    this.placeHolderPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.placeholder,
    this.alignment,
  });

  final String? imageUrl;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget? placeholder;

  final EdgeInsets placeHolderPadding;

  final Alignment? alignment;

  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
            width: width,
            height: height,
            fit: fit,
            imageBuilder: alignment != null
                ? (context, imageProvider) => DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          alignment: alignment!,
                        ),
                      ),
                    )
                : null,
            imageUrl: imageUrl!,
            progressIndicatorBuilder: (context, url, progress) => Skeleton(
              width: width ?? double.maxFinite,
              height: height ?? double.maxFinite,
              borderRadius: BorderRadius.zero,
            ),
            errorWidget: errorWidget ?? (context, _, error) => const Logo(),
          )
        : Padding(
            padding: placeHolderPadding,
            child:
                placeholder != null ? Center(child: placeholder) : const Logo(),
          );
  }
}
