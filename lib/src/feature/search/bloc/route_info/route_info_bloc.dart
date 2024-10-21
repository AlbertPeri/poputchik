import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_info_bloc.freezed.dart';
part 'route_info_event.dart';
part 'route_info_state.dart';

class RouteInfoBloc extends Bloc<RouteInfoEvent, RouteInfoState> {
  RouteInfoBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(const _Loading()) {
    on<_GetUserInfo>(_getUserInfo);
  }

  final IUserRepository _userRepository;
  String? _lastUserId;

  Future<void> _getUserInfo(
    _GetUserInfo event,
    Emitter<RouteInfoState> emit,
  ) async {
    try {
      emit(const _Loading());
      if (event.userId != null) {
        _lastUserId = event.userId;
      }
      final user =
          await _userRepository.fetchUser(userId: event.userId ?? _lastUserId);
      emit(_Loaded(user: user));
    } on UserException catch (error) {
      emit(_Error(message: error.message!));
    }
  }
}
