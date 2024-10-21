import 'dart:async';

import 'package:companion/src/feature/auth/data/authentication_repository.dart';
import 'package:companion/src/feature/notification/data/notification_repository.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with SetStateMixin<AuthState> {
  AuthBloc({
    required IAuthRepository authRepository,
    required INotificationsRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        _authRepository = authRepository,
        super(const AuthState.idle()) {
    on<AuthEvent>(
      (event, emit) => event.map(
        sendPhone: (_SendPhone event) => _onSendPhone(event, emit),
        checkAuthCode: (_CheckAuthCode event) => _onCheckAuthCode(event, emit),
        logout: (_LogOut event) => _onLogOut(event, emit),
      ),
    );

    _userSubscription = authRepository.user
        .where((user) => user != state.user)
        .map<AuthState>((u) => AuthState.idle(user: u))
        .listen(
      (event) async {
        setState(event);
        await _notificationRepository.savePushToken(user: state.user);
      },
      cancelOnError: false,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (pushToken) async {
        await _notificationRepository.savePushToken(
          user: state.user,
          pushToken: pushToken,
        );
      },
    );
  }

  final IAuthRepository _authRepository;

  final INotificationsRepository _notificationRepository;

  late StreamSubscription<AuthState?> _userSubscription;

  Future<void> _onSendPhone(_SendPhone event, Emitter<AuthState> emit) async {
    try {
      emit(
        AuthState.loading(
          phone: state.phone,
        ),
      );

      await _authRepository.sendPhone(phone: event.phone);
      return emit(
        AuthState.phonSend(
          phone: event.phone,
        ),
      );
    } on AuthException catch (error) {
      emit(
        AuthState.error(
          message: error.message,
          phone: state.phone,
        ),
      );
    } finally {
      emit(
        AuthState.notAuth(
          phone: state.phone,
        ),
      );
    }
  }

  Future<void> _onCheckAuthCode(
    _CheckAuthCode event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(
        AuthState.loading(
          phone: state.phone,
        ),
      );
      final phone = state.phone;
      if (phone != null) {
        final user = await _authRepository.checkAuthCode(
          phoneNumber: phone,
          verificationCode: event.verificationCode,
        );

        emit(
          AuthState.authenticated(
            userId: user.id.toString(),
            user: user,
            phone: phone,
          ),
        );
      } else {
        emit(
          AuthState.error(
            message: 'Ошибка при проверке кода',
            phone: state.phone,
          ),
        );
      }
    } on AuthException catch (error) {
      emit(
        AuthState.error(
          message: error.message,
          phone: state.phone,
        ),
      );
    } finally {
      emit(
        AuthState.notAuth(
          phone: state.phone,
        ),
      );
    }
  }

  Future<void> _onLogOut(_LogOut event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.logOut(
        userId: state.user?.id,
      );
    } on AuthException catch (error) {
      emit(
        AuthState.error(
          message: error.message,
          phone: state.phone,
        ),
      );
    } finally {
      emit(
        AuthState.notAuth(
          phone: state.phone,
        ),
      );
      notifier.value++;
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

mixin SetStateMixin<State extends Object?> implements Emittable<State> {
  final ValueNotifier<int> notifier = ValueNotifier(0);

  void setState(State state) {
    emit(state);
    notifier.value++;
  }
}
