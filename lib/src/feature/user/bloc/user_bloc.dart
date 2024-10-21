import 'dart:async';

import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required this.userRepository,
  }) : super(const UserState.initial()) {
    on<UserEvent>(
      (event, emit) => event.map(
        updateUser: (event) => _onUpdateUser(event, emit),
        fetchUser: (value) => _onFetchUser(event, emit),
        editUserProfile: (event) => _onEditUserProfile(event, emit),
      ),
    );

    _streamSubscription =
        userRepository.user.listen((user) => add(UserEvent.updateUser(user)));
  }

  final IUserRepository userRepository;

  late StreamSubscription<User?> _streamSubscription;

  Future<void> _onUpdateUser(
    _UpdateUser event,
    Emitter<UserState> emit,
  ) async {
    final user = event.user;

    if (user != null) {
      emit(state.copyWith(user: user));
    }
  }

  Future<void> _onEditUserProfile(
    _EditUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.updating(user: state.user));
    try {
      await userRepository.editUser(
        event.user!,
      );
      return emit(
        UserState.loaded(
          user: state.user,
        ),
      );
    } on UserException catch (error) {
      return emit(
        UserState.error(
          user: state.user,
          error: error.message,
        ),
      );
    } finally {
      emit(UserState.initial(user: state.user));
    }
  }

  Future<void> _onFetchUser(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.updating(user: state.user));
    try {
      await userRepository.fetchUser();
    } on UserException catch (error) {
      return emit(
        UserState.error(user: state.user, error: error.message),
      );
    } finally {
      emit(UserState.initial(user: state.user));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
