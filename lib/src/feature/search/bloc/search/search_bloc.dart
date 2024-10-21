import 'dart:async';

import 'package:companion/src/feature/search/data/search_exception.dart';
import 'package:companion/src/feature/search/data/search_repository.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:l/l.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required ISearchRepository searchRepository,
  })  : _searchRepository = searchRepository,
        super(const _Loading()) {
    on<_GetAllRoutes>(_getAllRoutes);

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(const _GetAllRoutes());
      l.s('Update routes');
    });
  }

  final ISearchRepository _searchRepository;

  Timer? _timer;

  Future<void> _getAllRoutes(
    _GetAllRoutes event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(const _Loading());
      final allRoutes = await _searchRepository.getAllRoutes();
      emit(_Loaded(routes: allRoutes.routes));
    } on SearchException catch (error) {
      emit(_Error(message: error.message!));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
