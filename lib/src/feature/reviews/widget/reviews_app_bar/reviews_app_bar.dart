import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _appbarHeight = 82.0;

class ReviewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReviewsAppBar({
    required this.rating,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  final double? rating;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      toolbarHeight: _appbarHeight,
      leading: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkButton(
                onTap: () => context.pop(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
                child: Assets.icons.icArrowBack.svg(),
              ),
              const SizedBox(height: _appbarHeight - 70),
            ],
          ),
        ),
      ),
      leadingWidth: 90,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(
                        avatarUrl!,
                      )
                    : null,
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 32,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 16.5,
                    color: AppColors.black3,
                  ),
                  Text(
                    rating == null
                        ? 'не указано'
                        : rating.toString().substring(0, 3),
                    style: AppTypography.sfPro12Medium.copyWith(
                      color: AppColors.textGreyColor.withOpacity(0.9),
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appbarHeight);
}
