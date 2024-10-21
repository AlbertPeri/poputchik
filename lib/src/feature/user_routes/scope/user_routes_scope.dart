import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user_routes/bloc/user_routes_bloc.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRoutesScope extends StatelessWidget {
  const UserRoutesScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope =
      BlocScope<UserRoutesEvent, UserRoutesState, UserRoutesBloc>();

  static NullaryScopeMethod get getRoutes => _scope.nullary(
        (context) => const UserRoutesEvent.getRoutes(),
      );

  static UnaryScopeMethod<int> get deleteRoute => _scope.unary(
        (context, id) => UserRoutesEvent.deleteRoute(id: id),
      );

  static UnaryScopeMethod<int> get completeRoute => _scope.unary(
        (context, id) => UserRoutesEvent.completeRoute(id: id),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserRoutesBloc>(
      create: (context) => UserRoutesBloc(
        userRoutesrepository: context.repository.userRoutesRepository,
      )..add(const UserRoutesEvent.getRoutes()),
      child: child,
    );
  }
}
