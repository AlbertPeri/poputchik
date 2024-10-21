import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/person_profile/bloc/person_bloc.dart';
import 'package:companion/src/feature/person_profile/widget/person_buttons_block/person_buttons_block.dart';
import 'package:companion/src/feature/person_profile/widget/person_info_block/person_info_block.dart';
import 'package:companion/src/feature/person_profile/widget/person_profile_app_bar/person_profile_app_bar.dart';
import 'package:companion/src/feature/person_profile/widget/scope/person_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonProfilePage extends StatefulWidget {
  const PersonProfilePage({
    required this.personId,
    super.key,
  });

  final int personId;

  @override
  State<PersonProfilePage> createState() => _PersonProfilePageState();
}

class _PersonProfilePageState extends State<PersonProfilePage> {
  @override
  void initState() {
    super.initState();
    PersonScope.getPerson(context, userId: widget.personId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PersonProfileAppBar(),
      body: SafeArea(
        child: BlocConsumer<PersonBloc, PersonState>(
          listener: (context, state) {},
          builder: (context, state) {
            final user = state.user;
            final hidePhone = user?.hidePhone ?? false;
            return state.maybeWhen(
              error: (user, error) => Center(
                child: Text(error.toString()),
              ),
              updating: (user) => const Center(
                child: Loader(),
              ),
              orElse: () {
                if (user == null) {
                  return const Center(child: Text('Пользователь не найден!'));
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 63),
                        PersonInfoBlock(
                          // avatarUrl:user. ,
                          personName: user.name == null || user.name!.isEmpty
                              ? 'Аноним'
                              : user.name!,
                          phoneNumber: hidePhone
                              ? ''
                              : user.phoneNumber ??
                                  'Отсутствует номер телефона',
                        ),
                        const SizedBox(height: 40),
                        PersonButtonsBlock(
                          phone: hidePhone ? '' : user.phoneNumber,
                          reviewReceiver: user.reviewReceiver,
                          averageRating: user.averageRating ?? 0,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
