import 'package:companion/src/feature/app/widget/app_bottom_nav_bar.dart';
import 'package:companion/src/feature/auth/bloc/auth_bloc.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/notification/widget/notification_reciever.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// {@template dashboard_page}
/// Главная страница
/// {@endtemplate}
class DashboardPage extends StatefulWidget {
  /// {@macro dashboard_page}
  const DashboardPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 1;

  void _goBranch(int index) {
    setState(() {
      _index = index;
    });

    widget.navigationShell.goBranch(
      _index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) => NotificationReciever(
        child: GestureDetector(
          onTap: FocusManager.instance.primaryFocus?.unfocus,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBody: true,
            bottomNavigationBar: AppBottomNavBar(
              onSelect: _goBranch,
              selectIndex: AuthScope.isAuthOf(context, listen: true)
                  ? widget.navigationShell.currentIndex
                  : _index,
            ),
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                final user = state.user;
                if (user != null) {
                  ChatsScope.getChatsList(context, user.id);
                }
                state.whenOrNull(
                  notAuth: (user, phone) => UserRoutesScope.getRoutes(context),
                );
              },
              child: widget.navigationShell,
            ),
          ),
        ),
      );
}
