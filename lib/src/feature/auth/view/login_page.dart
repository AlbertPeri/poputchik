import 'package:companion/gen/fonts.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/bloc/auth_bloc.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// {@template login_page}
/// LoginPage widget
/// {@endtemplate}
class LoginPage extends StatefulWidget {
  /// {@macro login_page}
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) => state.mapOrNull(
            error: (value) => context.toastService.showError(
              value.message ?? 'Ошибка!',
            ),
            phonSend: (value) => context.goNamed(RouteNames.codeInput),
            authenticated: (value) {
              context.toastService.showSuccess('Вход выполнен!');
              context.go(RouteLocations.userRoutes);
              return;
            },
          ),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Авторизация',
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaPro,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  const SizedBox(height: 23),
                  const Text(
                    textAlign: TextAlign.center,
                    '''Введите номер телефона на который\nбудет отправлен код подтверждения''',
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaPro,
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontFamily: FontFamily.sofiaPro,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                      ),
                      inputFormatters: [
                        TextInputFormatterX.phoneMask,
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: const InputDecoration(
                        hintText: '+7',
                        fillColor: Colors.transparent,
                        hintStyle: TextStyle(
                          fontFamily: FontFamily.sofiaPro,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: AppColors.textGreyColor,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(19, 25, 37, 0.4),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF3B30),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    isLoading: AuthScope.isLoading(context, listen: true),
                    text: 'Продолжить',
                    height: 60,
                    width: double.infinity,
                    onPressed: () {
                      final isValid = _phoneController.text
                              .replaceAll(RegExp('[+() ]'), '')
                              .length ==
                          11;
                      if (isValid) {
                        AuthScope.sendPhone(
                          context,
                          _phoneController.text.replaceAll(RegExp('[+ ]'), ''),
                        );
                      } else {
                        context.toastService.showError(
                          'Неправильно набран номер',
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
}
