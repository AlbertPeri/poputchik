import 'package:companion/src/feature/reviews/widget/review_card/review_card.dart';
import 'package:companion/src/feature/reviews/widget/reviews_app_bar/reviews_app_bar.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({
    required this.reviewReceiver,
    required this.rating,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  final List<Review> reviewReceiver;

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReviewsAppBar(
        avatarUrl: avatarUrl,
        rating: rating,
      ),
      body: SafeArea(
        child: reviewReceiver.isEmpty
            ? const Center(
                child: Text('Нет отзывов'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: reviewReceiver.length,
                itemBuilder: (context, index) {
                  return ReviewCard(
                    review: reviewReceiver[index],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 20),
              ),
      ),
    );
  }
}
