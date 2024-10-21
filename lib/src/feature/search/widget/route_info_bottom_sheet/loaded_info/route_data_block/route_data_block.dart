import 'dart:io';

import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RouteDataBlock extends StatelessWidget {
  const RouteDataBlock({
    required this.route,
    required this.user,
    super.key,
  });

  final Route route;

  final User user;

  static final _nunito14Style = AppTypography.nunito14Regular.copyWith(
    color: AppColors.textGreyColor,
  );

  @override
  Widget build(BuildContext context) {
    final isAuth = AuthScope.isAuthOf(context, listen: true);

    final currentUser = isAuth ? UserScope.userOf(context, listen: true) : null;
    final isCurrentUser = user.id == currentUser?.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _getPersonBlock(context, isCurrentUser),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _getDateBlock()),
            const SizedBox(width: 6),
            _getParticipantsBlock(),
          ],
        ),
        const SizedBox(height: 24),
        if (isAuth && !isCurrentUser) ...[
          Padding(
            padding: EdgeInsets.only(
              bottom: context.mediaQuery.viewInsets.bottom +
                  (Platform.isIOS ? 28 : 0),
            ),
            child: _getConnectButton(context),
          ),
        ],
      ],
    );
  }

  Widget _getPersonBlock(BuildContext context, bool isCurrentUser) {
    return GestureDetector(
      onTap: () {
        if (isCurrentUser) {
          context.go(
            RouteLocations.myProfile,
          );
        } else {
          context.pushNamed(
            RouteNames.personProfile,
            extra: {
              'personId': user.id,
            },
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.5, horizontal: 10),
        child: Row(
          children: [
            Assets.icons.icProfileBlack.svg(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${user.name ?? 'Аноним'} ${user.surname ?? ''}'.trimRight(),
                style: AppTypography.nunitoSans16Regular.copyWith(
                  color: AppColors.textGreyColor,
                ),
              ),
            ),
            if (user.averageRating != null) ...[
              Assets.icons.icStar.svg(),
              const SizedBox(width: 4),
              if (user.averageRating != null)
                Text(
                  user.averageRating.toString(),
                  style: AppTypography.nunito12Medium.copyWith(
                    color: AppColors.textGreyColor.withOpacity(0.9),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getDateBlock() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10),
      child: Row(
        children: [
          Assets.icons.icCalendar.svg(),
          const SizedBox(width: 7),
          Text(
            DateFormat.yMMMd('ru').add_jm().format(route.date),
            style: _nunito14Style,
          ),
        ],
      ),
    );
  }

  Widget _getParticipantsBlock() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 14.5),
      child: Row(
        children: [
          Assets.icons.icProfileBlack.svg(width: 18),
          const SizedBox(width: 6),
          Text(route.peopleAmount.toString(), style: _nunito14Style),
        ],
      ),
    );
  }

  Widget _getConnectButton(BuildContext context) {
    return SafeArea(
      child: RoundedButton(
        padding: const EdgeInsets.symmetric(vertical: 21.5),
        color: AppColors.black,
        child: Text(
          'Связаться',
          style: AppTypography.nunito14Medium.copyWith(color: AppColors.white),
        ),
        onTap: () {
          context.pushNamed(
            RouteNames.chat,
            queryParameters: {
              'targetId': user.id.toString(),
              'targetName': user.name,
              // "targetImage": user.,
              'targetPhone': user.phoneNumber,
            },
          );
        },
      ),
    );
  }
}
