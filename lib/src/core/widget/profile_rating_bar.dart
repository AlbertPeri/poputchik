import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfileRatingBar extends StatelessWidget {
  const ProfileRatingBar({
    this.initialRating,
    super.key,
  });

  final double? initialRating;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 21,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            allowHalfRating: true,
            ignoreGestures: true,
            maxRating: 5,
            initialRating: initialRating ?? 0,
            itemSize: 16.5,
            //itemPadding: const EdgeInsets.only(right: 4),
            itemBuilder: (_, index) => const Icon(
              Icons.star,
              color: AppColors.black3,
            ),
            onRatingUpdate: (value) {},
          ),
          const SizedBox(width: 4),
          Text(
            initialRating == null ? '' : initialRating!.toStringAsFixed(1),
            style: AppTypography.sfPro12Medium.copyWith(
              color: AppColors.black3.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
