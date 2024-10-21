// ignore_for_file: depend_on_referenced_packages

import 'package:companion/src/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pure/pure.dart';
import 'package:select_annotation/select_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'initialization_bloc.freezed.dart';
part 'initialization_bloc.select.dart';
part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(const InitializationState.notInitialized()) {
    on<InitializationEvent>(
      (event, emit) => event.map(
        initialize: (initialize) => _onInitialize(event, emit),
      ),
    );
  }

  InitializationProgress get _currentProgress =>
      state.maybeCast<_IndexedInitializationStateMixin>()?.progress ??
      InitializationProgress.initial();

  Future<void> _onInitialize(
    InitializationEvent event,
    Emitter<InitializationState> emit,
  ) async {
    emit(
      InitializationState.initializing(
        progress: InitializationProgress.initial(),
      ),
    );
    try {
      emit(
        InitializationState.initializing(
          progress: _currentProgress.copyWith(
            currentStep: InitializationStep.sharedPreferences,
          ),
        ),
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      emit(
        InitializationState.initialized(
          sharedPreferences: sharedPreferences,
        ),
      );
    } on Object catch (e, s) {
      emit(
        InitializationState.error(
          progress: _currentProgress,
          error: e,
          stackTrace: s,
        ),
      );
      rethrow;
    }
  }
}
