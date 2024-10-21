import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/my_profile/widget/edit_item_profile.dart';
import 'package:companion/src/feature/my_profile/widget/my_profile_app_bar.dart';
import 'package:companion/src/feature/my_profile/widget/my_profile_avatar.dart';
import 'package:companion/src/feature/my_profile/widget/my_profile_settings_item.dart';
import 'package:companion/src/feature/user/bloc/user_bloc.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// {@template profile_page}
/// Экран профиля
/// {@endtemplate}
class MyProfilePagege extends StatefulWidget {
  /// {@macro profile_page}
  const MyProfilePagege({super.key});

  @override
  State<MyProfilePagege> createState() => _MyProfilePagegeState();
}

class _MyProfilePagegeState extends State<MyProfilePagege> {
  final phoneMask = TextInputFormatterX.phoneMask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const ProfileAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const ProfileAppBar(),
          ];
        },
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            UserScope.getUser(context);
          },
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) => state.whenOrNull(
              error: (user, message) => context.toastService.showError(
                message ?? 'Ошибка, пользователь не найден',
              ),
            ),
            builder: (context, state) {
              final user = state.user;

              return state.maybeWhen(
                // updating: (user) => const Center(
                //   child: Loader(),
                // ),
                error: (user, error) => Center(
                  child: Text(
                    error ?? 'Ошибка, повторите попытку',
                  ),
                ),
                orElse: () {
                  final name = user?.name;
                  final hidePhone = user?.hidePhone;
                  return user == null
                      ? const EmptyPlaceholder()
                      : CustomScrollView(
                          physics: const ClampingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(kSidePadding),
                              sliver: SliverList.list(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 48),
                                    child: MyProfileAvatar(
                                      avatarUrl: user.image,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Center(
                                    child: Center(
                                      child: ProfileRatingBar(
                                        initialRating: user.averageRating ?? 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 26),
                                  MyProfileSettingsItem(
                                    title: name != null && name.isNotEmpty
                                        ? name
                                        : 'Введите имя',
                                    icon: Assets.icons.icProfileWhite.svg(),
                                    onTap: () => _onChangeName(context),
                                  ),
                                  const SizedBox(height: 10),
                                  MyProfileSettingsItem(
                                    title: user.phoneNumber != null
                                        ? phoneMask.maskText(
                                            user.phoneNumber?.substring(1) ??
                                                '',
                                          )
                                        : '',
                                    trailing: IconButton(
                                      tooltip: 'Показать/скрыть номер',
                                      icon: Icon(
                                        hidePhone == true
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 19,
                                      ),
                                      onPressed: () => _onHidePhone(context),
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    icon: Assets.icons.icPhoneNum.svg(),
                                  ),
                                ],
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: kBottomNavigationBarHeight * 2 + 20,
                                  ),
                                  child: TextButton(
                                    onPressed: () =>
                                        showDeleteAccountDialog(context),
                                    child: const Text('Удалить профиль'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void showDeleteAccountDialog(BuildContext context) =>
      AppDialog.showCustomDialog(
        context,
        title: 'Вы действительно хотите удалить аккаунт?',
        actionTitle: 'Удалить',
        onActionTap: () {
          context.pop();
          AuthScope.logOut(context);
          context.goNamed(RouteNames.userRoutes);
          context.toastService
              .showSuccess('Ваш запрос будет обработан в течении 24 часов');
        },
      );

  Future<void> _onHidePhone(BuildContext context) async {
    final user = UserScope.userOf(context);
    UserScope.updateUser(
      context,
      user: user.copyWith(
        hidePhone: !user.hidePhone,
      ),
    );
  }

  Future<void> _onChangeName(BuildContext context) async {
    final user = UserScope.userOf(context);
    final nameController = TextEditingController(
      text: user.name,
    );
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return EditItemProfile(
          title: 'Изменить имя',
          hintText: 'Имя',
          btnText: 'Сохранить',
          onPressed: () {
            UserScope.updateUser(
              context,
              user: user.copyWith(
                name: nameController.text,
              ),
            );
            context.pop();
          },
          controller: nameController,
        );
      },
    );
  }

  // Future<void> _onChangePhone(BuildContext context) async {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     backgroundColor: AppColors.backgroundColor,
  //     useRootNavigator: true,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return EditItemProfile(
  //         title: 'Изменить номер',
  //         hintText: 'Номер телефона',
  //         btnText: 'Отправить код',
  //         onPressed: () {},
  //         controller: TextEditingController(),
  //       );
  //     },
  //   );
  // }
}
