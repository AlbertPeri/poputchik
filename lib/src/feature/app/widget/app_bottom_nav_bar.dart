import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/extension/extension.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

/// {@template app_bottom_nav_bar}
/// Нижняя панель навигации
/// {@endtemplate}
class AppBottomNavBar extends StatelessWidget {
  /// {@macro app_bottom_nav_bar}
  const AppBottomNavBar({
    required this.selectIndex,
    required this.onSelect,
    super.key,
  });

  final int selectIndex;

  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuery.size.width;
    final isSmall = width < 430;
    final padding = EdgeInsets.fromLTRB(
      isSmall ? 8 : 20,
      0,
      isSmall ? 8 : 20,
      10,
    );
    final count =
        ChatsScope.chatsListOf(context, listen: true).where((element) {
      final latestMessage = element.latestMessage;

      return latestMessage != null &&
          !latestMessage.isSeen &&
          latestMessage.userId != UserScope.userOf(context).id;
    }).length;
    return Container(
      color: AppColors.backgroundColor,
      padding: padding,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: GNav(
            selectedIndex: selectIndex,
            onTabChange: onSelect,
            gap: 6,
            tabs: [
              GButton(
                haptic: true,
                textSize: 10,
                text: 'Поиск',
                icon: Icons.search,
                leading: Assets.icons.icSearch.svg(width: 20, height: 20),
                padding: const EdgeInsets.all(13),
              ),
              GButton(
                haptic: true,
                text: 'Поездки',
                icon: Icons.explore,
                leading: Assets.icons.icDiscovery.svg(width: 20, height: 20),
                padding: const EdgeInsets.all(13),
              ),
              GButton(
                haptic: true,
                text: 'Чаты',
                icon: Icons.mail,
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Assets.icons.icMessage.svg(width: 20, height: 20),
                    Positioned(
                      top: -2,
                      right: -4,
                      child: Badge(
                        isLabelVisible: count != 0,
                        largeSize: 12,
                        smallSize: 8,
                        textColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 8),
                        label: Text('$count'),
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(13),
              ),
              GButton(
                haptic: true,
                text: 'Профиль',
                icon: Icons.person,
                leading: Assets.icons.icProfile.svg(height: 24, width: 24),
                padding: const EdgeInsets.all(13),
              ),
            ],
            tabBackgroundColor: Colors.white,
            backgroundColor: AppColors.accentColor,
            tabBorderRadius: 33,
            color: AppColors.black2,
            padding: const EdgeInsets.all(13),
            activeColor: Colors.white,
            tabMargin: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            textStyle: AppTypography.nunito14Medium,
          ),
        ),
      ),
    );
  }
}
