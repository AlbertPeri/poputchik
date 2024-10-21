import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RatingButton extends StatelessWidget {
  const RatingButton({
    required this.avatarUrl,
    required this.reviewReceiver,
    required this.averageRating,
    super.key,
  });

  final String? avatarUrl;

  final List<Review> reviewReceiver;

  final double averageRating;

  void _openReviews(BuildContext context) {
    context.pushNamed(
      RouteNames.reviews,
      extra: {
        'avatarUrl': avatarUrl,
        'reviewReceiver': reviewReceiver,
        'rating': averageRating,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onTap: () => _openReviews(context),
      color: AppColors.white.withOpacity(0.5),
      overlayColor: AppColors.black.withOpacity(0.1),
      borderRadius: 35,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Text(
            'Рейтинг',
            style: AppTypography.nunito12Medium.copyWith(
              color: AppColors.black3.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProfileRatingBar(
                initialRating: averageRating,
              ),
              Text(
                '${reviewReceiver.length} отз.',
                style: AppTypography.nunito12Medium.copyWith(
                  color: AppColors.blueColor2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Assets.icons.icRightArrow.svg(
            colorFilter: ColorFilter.mode(
              AppColors.black.withOpacity(0.3),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
