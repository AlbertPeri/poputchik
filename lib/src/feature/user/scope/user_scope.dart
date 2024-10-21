import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user/bloc/user_bloc.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

User _user(UserState state) => state.user!;

bool _isLoading(UserState state) => state.isProcessing;

bool _isIdling(UserState state) => state.isIdling;

class UserScope extends StatelessWidget {
  const UserScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const BlocScope<UserEvent, UserState, UserBloc> _scope = BlocScope();

  static ScopeData<User> get userOf => _scope.select(_user);

  static ScopeData<bool> get isLoadingOf => _scope.select(_isLoading);

  static ScopeData<bool> get isIdlingOf => _scope.select(_isIdling);

  static NullaryScopeMethod get getUser => _scope.nullary(
        (context) => const UserEvent.fetchUser(),
      );

  static void updateUser(
    BuildContext context, {
    required User user,
  }) {
    context.read<UserBloc>().add(
          UserEvent.editUserProfile(
            user: user,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => BlocProvider<UserBloc>(
        lazy: false,
        create: (context) => UserBloc(
          userRepository: context.repository.userRepository,
        )..add(const UserEvent.fetchUser()),
        child: child,
      );
}
