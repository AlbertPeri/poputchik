part of 'initialization_bloc.dart';

@freezed
class InitializationState with _$InitializationState {
  const InitializationState._();

  const factory InitializationState.notInitialized() =
      InitializationNotInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.initializing({
    required InitializationProgress progress,
  }) = InitializationInitializing;

  @Implements<InitializationData>()
  const factory InitializationState.initialized({
    required SharedPreferences sharedPreferences,
  }) = InitializationInitialized;

  @With<_IndexedInitializationStateMixin>()
  const factory InitializationState.error({
    required InitializationProgress progress,
    required Object error,
    required StackTrace stackTrace,
  }) = InitializationError;

  int get stepsCompleted => map(
        notInitialized: 0.constant,
        initializing: _IndexedInitializationStateMixin$.stepsCompleted,
        initialized: InitializationStep.values.length.constant,
        error: _IndexedInitializationStateMixin$.stepsCompleted,
      );
}

@matchable
enum InitializationStep {
  environment,
  errorTracking,
  sharedPreferences,
}

@selectable
abstract class InitializationData {
  SharedPreferences get sharedPreferences;
}

@freezed
class InitializationProgress with _$InitializationProgress {
  const factory InitializationProgress({
    required InitializationStep currentStep,
  }) = _InitializationProgress;

  const InitializationProgress._();

  factory InitializationProgress.initial() => InitializationProgress(
        currentStep: InitializationStep.values.first,
      );

  int get stepsCompleted => InitializationStep.values.indexOf(currentStep);
}

@selectable
mixin _IndexedInitializationStateMixin {
  InitializationProgress get progress;

  int get stepsCompleted => progress.stepsCompleted;
}
