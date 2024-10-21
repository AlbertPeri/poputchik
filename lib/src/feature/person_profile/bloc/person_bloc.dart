import 'package:companion/src/feature/person_profile/data/person_repository.dart';
import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_bloc.freezed.dart';
part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc({
    required IPersonRepository personRepository,
  })  : _personRepository = personRepository,
        super(const PersonState.initial()) {
    on<_GetPersonEvent>(_onGetPerson);
    on<_PostReviewEvent>(_onPostReview);
  }

  final IPersonRepository _personRepository;

  Future<void> _onGetPerson(
    _GetPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(PersonState.updating(user: state.user));
      final user = await _personRepository.getPerson(userId: event.userId);
      return emit(PersonState.loaded(user: user));
    } on UserException catch (error) {
      return emit(PersonState.error(user: state.user, error: error.message));
    } on Object catch (error) {
      return emit(PersonState.error(user: state.user, error: error.toString()));
    }
  }

  Future<void> _onPostReview(
    _PostReviewEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(PersonState.updating(user: state.user));
      await _personRepository.postReview(
        senderId: event.senderId,
        receiverId: event.receiverId,
        content: event.content,
        rating: event.rating,
      );
      add(PersonEvent.getPerson(userId: event.receiverId));
      return emit(PersonState.loaded(user: state.user));
    } on UserException catch (error) {
      return emit(PersonState.error(user: state.user, error: error.message));
    } on Object catch (error) {
      return emit(PersonState.error(user: state.user, error: error.toString()));
    }
  }
}
