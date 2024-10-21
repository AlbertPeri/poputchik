import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/widget/review_widget.dart';
import 'package:companion/src/feature/person_profile/widget/scope/person_scope.dart';
import 'package:flutter/material.dart';

class LeaveReviewButton extends StatelessWidget {
  const LeaveReviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onTap: () {
        final person = PersonScope.personOf(context);
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) => ReviewWidget(person: person),
        );
      },
      color: AppColors.textBlackColor,
      borderRadius: 35,
      child: Text(
        'Оставить отзыв',
        style: AppTypography.nunito16Medium.copyWith(
          color: AppColors.backgroundColor,
          height: 28.64 / 16,
        ),
      ),
    );
  }
}
