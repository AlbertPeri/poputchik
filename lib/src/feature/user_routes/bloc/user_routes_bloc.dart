import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_exception.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_repository.dart';
import 'package:companion_api/companion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_routes_bloc.freezed.dart';
part 'user_routes_event.dart';
part 'user_routes_state.dart';

class UserRoutesBloc extends Bloc<UserRoutesEvent, UserRoutesState> {
  UserRoutesBloc({
    required IUserRoutesRepository userRoutesrepository,
  })  : _userRoutesRepository = userRoutesrepository,
        super(const _Loading()) {
    on<_GetRoutes>(_getRoutes);
    on<_DeleteRoute>(_deleteRoute);
    on<_CompleteRoute>(_completeRoute);
  }

  final IUserRoutesRepository _userRoutesRepository;

  Future<void> _getRoutes(
    _GetRoutes event,
    Emitter<UserRoutesState> emit,
  ) async {
    try {
      emit(const _Loading());
      final userRoutes = await _userRoutesRepository.getUserRoutes();
      emit(_Loaded(routes: userRoutes));
    } on UserRoutesException catch (error) {
      emit(_Error(message: error.message!));
    }
  }

  Future<void> _deleteRoute(
    _DeleteRoute event,
    Emitter<UserRoutesState> emit,
  ) async {
    final loadedRoutes = state as _Loaded;
    try {
      final routeDeleted =
          await _userRoutesRepository.deleteRoute(id: event.id);
      if (routeDeleted) {
        emit(const _Deleted());
        final routesCopy = List<Route>.from(loadedRoutes.routes);
        final modifableRoutes = routesCopy
          ..removeWhere((route) => route.id == event.id);
        emit(_Loaded(routes: modifableRoutes));
      } else {
        emit(
          const _Error(
            message: 'Не получилось удалить поездку, попробуйте позже',
            actionError: true,
          ),
        );
        emit(loadedRoutes);
      }
    } on UserRoutesException catch (error) {
      emit(_Error(message: error.message!, actionError: true));
      emit(loadedRoutes);
    }
  }

  Future<void> _completeRoute(
    _CompleteRoute event,
    Emitter<UserRoutesState> emit,
  ) async {
    final loadedRoutes = state as _Loaded;
    try {
      final updatedRoute = await _userRoutesRepository.changeRouteStatus(
        id: event.id,
        status: RouteStatus.completed,
      );
      emit(const _Completed());
      final indexOfUpdated = loadedRoutes.routes.indexWhere(
        (route) => route.id == updatedRoute.id,
      );
      final routesCopy = List<Route>.from(loadedRoutes.routes);
      routesCopy[indexOfUpdated] = updatedRoute;
      emit(_Loaded(routes: routesCopy));
    } on UserRoutesException catch (error) {
      emit(_Error(message: error.message!, actionError: true));
      emit(loadedRoutes);
    }
  }
}
