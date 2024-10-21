import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Виджет для отображения изображений
class ImagesSlider extends StatefulWidget {
  const ImagesSlider({
    required this.images, required this.height, super.key,
    this.viewportFraction = 1.0,
    this.separationValue = 0,
    this.radius = 0,
    this.imageAlignment,
    this.isAsset = false,
  });

  factory ImagesSlider.asset({
    required List<String> images,
    required double height,
    double viewportFraction = 1.0,
    double separationValue = 0,
    double radius = 0,
    Alignment? imageAlignment,
  }) =>
      ImagesSlider(
        images: images,
        height: height,
        imageAlignment: imageAlignment,
        isAsset: true,
        radius: radius,
        separationValue: separationValue,
        viewportFraction: viewportFraction,
      );

  final List<String> images;

  final double height;

  final double viewportFraction;

  final double separationValue;

  final double radius;

  final Alignment? imageAlignment;

  final bool isAsset;

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: widget.images.isEmpty
                  ? [
                      ImageWidget(
                        fit: BoxFit.cover,
                        alignment: widget.imageAlignment,
                        placeHolderPadding: const EdgeInsets.all(kSidePadding),
                      ),
                    ]
                  : widget.images
                      .map(
                        (url) => widget.isAsset
                            ? Image.asset(
                                url,
                                fit: BoxFit.cover,
                              )
                            : ImageWidget(
                                imageUrl: url,
                                alignment: widget.imageAlignment,
                                fit: BoxFit.cover,
                              ),
                      )
                      .toList(),
            ),
            if (widget.images.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Align(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.images.length,
                    effect: WormEffect(
                      activeDotColor: context.theme.primaryColor,
                      dotColor: context.theme.primaryColor.withOpacity(.5),
                      dotHeight: 7,
                      dotWidth: 7,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
