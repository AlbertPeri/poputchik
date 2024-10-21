import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/settings/widget/theme_button.dart';
import 'package:flutter/material.dart';

/// {@template home_page}
/// Домашняя страница
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(context.localized.homeLabel),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(kSidePadding),
            sliver: SliverList.list(
              children: const [ThemeButton()],
            ),
          ),
        ],
      ),
    );
  }
}
