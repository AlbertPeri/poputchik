import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/person_profile/bloc/person_bloc.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

User _user(PersonState state) => state.user!;

bool _isLoading(PersonState state) => state.isProcessing;

bool _isIdling(PersonState state) => state.isIdling;

class PersonScope extends StatelessWidget {
  const PersonScope({
    required this.child,
    super.key,
  });
  final Widget child;

  static const BlocScope<PersonEvent, PersonState, PersonBloc> _scope =
      BlocScope();

  static ScopeData<User> get personOf => _scope.select(_user);

  static ScopeData<bool> get isLoadingOf => _scope.select(_isLoading);

  static ScopeData<bool> get isIdlingOf => _scope.select(_isIdling);

  // static NullaryScopeMethod get sendMessage => _scope.nullary(
  //       (context, ) => const ChatEvent.sendMessage(),
  //     );

  static Future<void> getPerson(
    BuildContext context, {
    required String userId,
  }) async {
    context.read<PersonBloc>().add(
          PersonEvent.getPerson(
            userId: userId,
          ),
        );
  }

  static Future<void> postReview(
    BuildContext context, {
    required String userId,
    required String content,
    required int rating,
    required String receiverId,
  }) async {
    context.read<PersonBloc>().add(
          PersonEvent.postReview(
            senderId: userId,
            receiverId: receiverId,
            content: content,
            rating: rating,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => BlocProvider<PersonBloc>(
        create: (context) => PersonBloc(
          personRepository: context.repository.personRepository,
        ),
        child: child,
      );
}
