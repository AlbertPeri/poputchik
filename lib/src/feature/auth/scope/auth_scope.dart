import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScope extends StatelessWidget {
  const AuthScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const BlocScope<AuthEvent, AuthState, AuthBloc> _scope = BlocScope();

  static ScopeData<bool> get isLoading => _scope.select(
        (state) => state.maybeMap(
          orElse: () => false,
          loading: (_) => true,
        ),
      );

  static ScopeData<bool> get isAuthOf => _scope.select(
        (state) => state.user != null,
      );

  static ScopeData<String?> get phoneOf =>
      _scope.data((context, state) => state.phone);

  static bool isValidPhoneOf(BuildContext context) {
    final phone = phoneOf(context);
    return phone != null && phone.onlyDigits.length == 11;
  }

  static UnaryScopeMethod<String> get sendPhone => _scope.unary(
        (context, phone) => AuthEvent.sendPhone(phone: phone),
      );

  static UnaryScopeMethod<String> get checkCode => _scope.unary(
        (context, code) => AuthEvent.checkAuthCode(verificationCode: code),
      );

  static NullaryScopeMethod get logOut =>
      _scope.nullary((context) => const AuthEvent.logout());

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
        lazy: false,
        create: (context) => AuthBloc(
          authRepository: context.repository.authRepository,
          notificationRepository: context.repository.notificationsRepository,
        ),
        child: child,
      );
}
