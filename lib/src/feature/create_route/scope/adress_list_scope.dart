import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/adresses_list/adresses_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdressListScope extends StatelessWidget {
  const AdressListScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const _scope =
      BlocScope<AdressesListEvent, AdressesListState, AdressesListBloc>();

  static UnaryScopeMethod<String> get searchByQuery => _scope.unary(
        (context, query) => AdressesListEvent.searchByQuery(query: query),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdressesListBloc>(
      create: (context) => AdressesListBloc(
        adressesRepository: context.repository.adressesRepository,
      ),
      child: child,
    );
  }
}
