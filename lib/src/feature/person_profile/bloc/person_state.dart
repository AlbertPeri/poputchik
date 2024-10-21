part of 'person_bloc.dart';

@freezed
class PersonState with _$PersonState {
  const PersonState._();
  const factory PersonState.initial({
    User? user,
  }) = _PersonInitialState;

  const factory PersonState.updating({
    User? user,
  }) = _PersonUpdatingState;

  const factory PersonState.loaded({
    User? user,
  }) = _PersonLoadedlState;

  const factory PersonState.error({
    User? user,
    String? error,
  }) = _PersonErrorState;

  // If an error has occurred
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  bool get isIdling => !isProcessing;

  bool get isLoaded => maybeMap<bool>(orElse: () => false, loaded: (_) => true);

  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, updating: (_) => true);
}
