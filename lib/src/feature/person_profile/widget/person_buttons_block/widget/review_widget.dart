import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/widget/btn_review.dart';
import 'package:companion/src/feature/person_profile/widget/scope/person_scope.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

/// {@template review_widget}
/// ReviewWidget widget
/// {@endtemplate}
class ReviewWidget extends StatefulWidget {
  /// {@macro review_widget}
  const ReviewWidget({
    required this.person,
    super.key,
  });

  final User person;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final TextEditingController contentController = TextEditingController();

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    final user = UserScope.userOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        context.mediaQuery.viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            if (widget.person.name != null) ...[
              Text(
                '${widget.person.surname ?? ''} ${widget.person.name ?? ''}',
                style: AppTypography.sfPro17Bold,
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Поставить оценку',
              style: AppTypography.nunito12Regular,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: RatingBar.builder(
                initialRating: rating,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 2.5,
                ),
                itemSize: 24,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.black3,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: TextField(
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Поделитесь своими впечатлениями о поездке',
                  hintStyle: AppTypography.textSuperSmall12Regular,
                  contentPadding: const EdgeInsets.all(24),
                  filled: true,
                  fillColor: AppColors.darkBlueColor2,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  BtnReview(
                    text: 'Отмена',
                    color: Colors.white,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  BtnReview(
                    text: 'Опубликовать',
                    color: Colors.black,
                    onTap: () {
                      if (rating == 0) {
                        context.toastService.showError('Поставьте оценку');
                      } else {
                        PersonScope.postReview(
                          context,
                          userId: user.id.toString(),
                          content: contentController.text,
                          rating: rating.toInt(),
                          receiverId: widget.person.id.toString(),
                        );
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
