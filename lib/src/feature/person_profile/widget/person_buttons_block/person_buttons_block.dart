import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/extension/src/messenger.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/leave_review_button/leave_review_button.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/rating_button/rating_button.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/upper_action_button/upper_action_button.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class PersonButtonsBlock extends StatelessWidget {
  const PersonButtonsBlock({
    required this.reviewReceiver,
    required this.averageRating,
    required this.phone,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  final String? phone;

  final List<Review> reviewReceiver;

  final double averageRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Expanded(
            //   child: UpperActionButton(
            //     onTap: () => context.pop(),
            //     text: 'Написать',
            //   ),
            // ),
            if (phone != null && phone!.onlyDigits.length == 11) ...[
              const SizedBox(width: 6),
              Expanded(
                child: UpperActionButton(
                  onTap: () {
                    if (phone != null) {
                      return UrlLauncher.callPhone(
                        TextInputFormatterX.phoneMask
                            .maskText(phone!.substring(1)),
                      );
                    }

                    return context.messenger
                        .showMessage('Не указан номер телефона');
                  },
                  text: 'Позвонить',
                ),
              ),
            ],
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: LeaveReviewButton(),
        ),
        if (reviewReceiver.isNotEmpty)
          RatingButton(
            avatarUrl: avatarUrl,
            averageRating: averageRating,
            reviewReceiver: reviewReceiver,
          ),
      ],
    );
  }
}
