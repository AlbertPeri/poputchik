part of 'person_bloc.dart';

@freezed
class PersonEvent with _$PersonEvent {
  const factory PersonEvent.getPerson({
    required String userId,
  }) = _GetPersonEvent;

  const factory PersonEvent.postReview({
    required String senderId,
    required String receiverId,
    required String content,
    required int rating,
  }) = _PostReviewEvent;
}
