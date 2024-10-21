// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:companion/src/core/core.dart';
import 'package:companion/src/core/router/navigator_observers_factory.dart';
import 'package:companion/src/feature/app/view/dashboard_page.dart';
import 'package:companion/src/feature/auth/bloc/auth_bloc.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/auth/view/code_input_page.dart';
import 'package:companion/src/feature/auth/view/login_page.dart';
import 'package:companion/src/feature/chat/scope/chat_scope.dart';
import 'package:companion/src/feature/chat/view/chat_page.dart';
import 'package:companion/src/feature/chats/models/chats/chats.dart';
import 'package:companion/src/feature/chats/view/chats_page.dart';
import 'package:companion/src/feature/create_route/view/create_route_page.dart';
import 'package:companion/src/feature/my_profile/view/my_profile_page.dart';
import 'package:companion/src/feature/person_profile/view/person_profile_page.dart';
import 'package:companion/src/feature/reviews/view/reviews_page.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/view/search_page.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/bottom_sheet_service.dart';
import 'package:companion/src/feature/splash/view/splash_page.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:companion/src/feature/user_routes/view/user_routes_page.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

typedef RouterWidgetBuilder = Widget Function(
  BuildContext context,
  RouterConfig<Object>? routerConfig,
);

class AppRouterBuilder extends StatefulWidget {
  const AppRouterBuilder({
    required this.builder,
    super.key,
  });
  final RouterWidgetBuilder builder;

  @override
  State<AppRouterBuilder> createState() => _AppRouterBuilderState();
}

class _AppRouterBuilderState extends State<AppRouterBuilder> {
  final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
    debugLabel: 'search',
  );
  final _shellNavigatorUserRoutesKey = GlobalKey<NavigatorState>(
    debugLabel: 'user_routes',
  );

  final _shellNavigatorChatsKey = GlobalKey<NavigatorState>(
    debugLabel: 'chats',
  );
  final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
    debugLabel: 'profile',
  );

  final _loginNavigatorProfileKey = GlobalKey<NavigatorState>(
    debugLabel: 'login',
  );

  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  late final GoRouter router = GoRouter(
    observers: const NavigatorObserversFactory().call(),
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: RouteLocations.userRoutes,
    refreshListenable: context.read<AuthBloc>().notifier,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteLocations.splash,
        pageBuilder: (context, state) => const MaterialPage(
          child: SplashPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => DashboardPage(
          navigationShell: child,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: RouteLocations.search,
                name: RouteNames.search,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SearchPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorUserRoutesKey,
            routes: [
              GoRoute(
                path: RouteLocations.userRoutes,
                name: RouteNames.userRoutes,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: UserRoutesPage(),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: RouteLocations.createRoute,
                    name: RouteNames.createRoute,
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final route = extra?['routeToEdit'] as Route?;

                      return MaterialPage(
                        child: CreateRoutePage(routeToEdit: route),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChatsKey,
            routes: [
              GoRoute(
                redirect: (context, state) {
                  final isAuth = !AuthScope.isAuthOf(context);

                  return isAuth ? RouteLocations.login : null;
                },
                path: RouteLocations.chats,
                name: RouteNames.chats,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatsPage(),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: RouteLocations.chat,
                    name: RouteNames.chat,
                    pageBuilder: (context, state) {
                      final extra = state.extra as Chats?;

                      final targetId = state.queryParameters['targetId'];
                      final chatId = state.queryParameters['chatId'];
                      final targetName = state.queryParameters['targetName'];
                      final targetAvatar =
                          state.queryParameters['targetAvatar'];
                      final targetPhone = state.queryParameters['targetPhone'];
                      final latestMessageId =
                          state.queryParameters['latestMessageId'];
                      return CupertinoPage(
                        child: ChatScope(
                          child: ChatPage(
                            chatId: chatId,
                            phone: targetPhone,
                            targetAvatar: targetAvatar,
                            targetName: targetName,
                            info: extra,
                            latesMessageId: int.tryParse(latestMessageId ?? ''),
                            targetId:
                                targetId == null ? null : int.parse(targetId),
                          ),
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: RouteLocations.personProfile,
                        name: RouteNames.personProfile,
                        pageBuilder: (context, state) {
                          final extra = state.extra! as Map<String, dynamic>;

                          return MaterialPage(
                            child: PersonProfilePage(
                              personId: extra['personId'] as int,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: RouteLocations.reviews,
                            name: RouteNames.reviews,
                            pageBuilder: (context, state) {
                              final extra =
                                  state.extra! as Map<String, dynamic>;

                              return CupertinoPage(
                                child: ReviewsPage(
                                  avatarUrl: extra['avatarUrl'] as String?,
                                  reviewReceiver:
                                      extra['reviewReceiver'] as List<Review>,
                                  rating: extra['rating'] as double,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                redirect: (context, state) =>
                    !AuthScope.isAuthOf(context) ? RouteLocations.login : null,
                path: RouteLocations.myProfile,
                name: RouteNames.myProfile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MyProfilePagege(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _loginNavigatorProfileKey,
            routes: [
              GoRoute(
                path: RouteLocations.login,
                name: RouteNames.login,
                pageBuilder: (context, state) => CupertinoPage(
                  key: state.pageKey,
                  name: state.name,
                  child: const LoginPage(),
                ),
                routes: [
                  GoRoute(
                    path: RouteLocations.codeInput,
                    name: RouteNames.codeInput,
                    pageBuilder: (context, state) => CupertinoPage(
                      key: state.pageKey,
                      name: state.name,
                      child: CodeInputPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DependenciesScope.of(context).toastService.init(
            _rootNavigatorKey.currentContext!,
          );
    });
    router.addListener(_onRouteChange);
  }

  void _onRouteChange() {
    // Закрываем BottomSheet при любом изменении маршрута
    bottomSheetService.closeBottomSheet();
  }

  @override
  void dispose() {
    router
      ..removeListener(_onRouteChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        router,
      );
}
