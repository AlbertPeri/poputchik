import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/search/bloc/search/search_bloc.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScope extends StatelessWidget {
  const SearchScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope = BlocScope<SearchEvent, SearchState, SearchBloc>();

  static NullaryScopeMethod get getAllRoutes => _scope.nullary(
        (context) => const SearchEvent.getAllRoutes(),
      );

  static ScopeData<List<Route>?> get routesOrNull => _scope.select(
        (state) => state.maybeMap(
          orElse: () => null,
          loaded: (data) => data.routes,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        searchRepository: context.repository.searchRepository,
      )..add(const SearchEvent.getAllRoutes()),
      child: child,
    );
  }
}
