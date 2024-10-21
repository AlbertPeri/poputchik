part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.idle() = _Idle;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.error({required String message}) = _Error;
  const factory SearchState.loaded({required List<Route> routes}) = _Loaded;
}
