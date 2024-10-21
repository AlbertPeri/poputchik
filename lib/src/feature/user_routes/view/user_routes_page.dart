import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/search/scope/search_scope.dart';
import 'package:companion/src/feature/user_routes/bloc/user_routes_bloc.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:companion/src/feature/user_routes/widget/create_route_button/create_route_button.dart';
import 'package:companion/src/feature/user_routes/widget/loaded_routes/loaded_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRoutesPage extends StatelessWidget {
  const UserRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    centerTitle: false,
                    scrolledUnderElevation: 0,
                    title: Text(
                      'Ваши поездки',
                      style: AppTypography.sfPro30Medium,
                    ),
                  ),
                ];
              },
              body: Center(
                child: RefreshIndicator.adaptive(
                  onRefresh: () async => UserRoutesScope.getRoutes(context),
                  color: AppColors.black,
                  child: BlocConsumer<UserRoutesBloc, UserRoutesState>(
                    listener: _userRoutesListener,
                    buildWhen: (pr, cu) => cu.maybeWhen(
                      loading: () => true,
                      error: (_, actionError) => !actionError,
                      loaded: (_) => true,
                      orElse: () => false,
                    ),
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Loader(),
                        error: (message, _) => EmptyPlaceholder(
                          message: message,
                        ),
                        loaded: (routes) => LoadedRoutes(routes: routes),
                        orElse: SizedBox.shrink,
                      );
                    },
                  ),
                ),
              ),
            ),
            if (AuthScope.isAuthOf(context, listen: true))
              const Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: CreateRouteButton(),
              ),
          ],
        ),
      ),
    );
  }

  void _userRoutesListener(BuildContext context, UserRoutesState state) {
    state.maybeWhen(
      deleted: () {
        context.toastService.showSuccess('Поездка удалена!');
        UserRoutesScope.getRoutes(context);
        SearchScope.getAllRoutes(context);
      },
      completed: () => context.toastService.showSuccess('Поездка завершена!'),
      edited: () {
        context.toastService.showSuccess('Данные поездки изменены!');
        UserRoutesScope.getRoutes(context);
        SearchScope.getAllRoutes(context);
      },
      error: (message, actionError) {
        if (actionError) {
          context.toastService.showError(message);
        }
      },
      orElse: () {},
    );
  }
}
