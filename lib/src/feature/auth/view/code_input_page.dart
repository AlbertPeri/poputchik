import 'package:companion/gen/fonts.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/bloc/auth_bloc.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

/// {@template code_input_page}
/// CodeInputPage widget
/// {@endtemplate}
class CodeInputPage extends StatelessWidget {
  /// {@macro code_input_page}
  CodeInputPage({super.key});

  final _smsCodeController = TextEditingController();

  static bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) => state.mapOrNull(
          authenticated: (value) => context.go(RouteLocations.myProfile),
          error: (value) {
            isError = true;
            context.toastService.showError(value.message ?? 'Ошибка!');
            return null;
          },
          loading: (value) => isError = false,
        ),
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Авторизация',
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaPro,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: AppColors.textBlackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    textAlign: TextAlign.center,
                    'Скоро вам позвонят, чтобы продиктовать код доступа. Введите его ниже',
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaPro,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Pinput(
                    onCompleted: (value) => AuthScope.checkCode(
                      context,
                      _smsCodeController.text,
                    ),
                    forceErrorState: isError,
                    controller: _smsCodeController,
                    autofocus: true,
                    defaultPinTheme: const PinTheme(
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      width: 34,
                      height: 40,
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.sofiaPro,
                        color: AppColors.textBlackColor,
                      ),
                    ),
                    errorPinTheme: const PinTheme(
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFFF3B30),
                          ),
                        ),
                      ),
                      width: 34,
                      height: 40,
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.sofiaPro,
                        color: AppColors.textBlackColor,
                      ),
                    ),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    listenForMultipleSmsOnAndroid: true,
                    enableIMEPersonalizedLearning: true,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                  // const SizedBox(height: 39),
                  // AppButton(
                  //   text: 'Продолжить',
                  //   height: 60,
                  //   width: double.infinity,
                  //   onPressed: () {
                  //     AuthScope.checkCode(
                  //       context,
                  //       _smsCodeController.text,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class ErrorMessage extends StatelessWidget {
//   const ErrorMessage({
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 42,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(255, 95, 95, 0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error,
//             color: Color(0xFFFF3B30),
//           ),
//           SizedBox(width: 10),
//           Text(
//             'Ошибка!',
//             style: TextStyle(
//               fontFamily: FontFamily.sofiaPro,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFFFF3B30),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
