import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/bloc/route_info/route_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteInfoScope extends StatelessWidget {
  const RouteInfoScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope =
      BlocScope<RouteInfoEvent, RouteInfoState, RouteInfoBloc>();

  static UnaryScopeMethod<String?> get getUserInfo => _scope.unary(
        (context, userId) => RouteInfoEvent.getUserInfo(userId: userId),
      );

  // static ScopeData<List<Route>?> get routesOrNull => _scope.select(
  //       (state) => state.maybeMap(
  //         orElse: () => null,
  //         loaded: (data) => data.routes,
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RouteInfoBloc>(
      create: (context) => RouteInfoBloc(
        userRepository: context.repository.userRepository,
      ),
      child: child,
    );
  }
}
