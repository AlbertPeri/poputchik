import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    required this.review,
    super.key,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.senderName ?? 'Aноним',
            style: AppTypography.nunitoSans14Bold,
          ),
          ProfileRatingBar(initialRating: review.rating),
          const SizedBox(height: 10),
          Text(
            review.content ?? '',
            style: AppTypography.nunito12Regular,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              review.createdAt.parseDateTime().pretty(),
              style: AppTypography.nunito8SemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
