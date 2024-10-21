import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/create_route/create_route_bloc.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:flutter/cupertino.dart' hide Route;

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.state,
    required this.editRoute,
    super.key,
  });

  final CreateRouteState state;
  final bool editRoute;

  @override
  Widget build(BuildContext context) {
    final buttonIsActive = CreateRouteScope.buttonIsActive(context);

    return RoundedButton(
      color: AppColors.black,
      borderRadius: 35,
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 24.5),
      showDisabledColor: true,
      onTap: buttonIsActive ? () => _onSubmitTap(context) : null,
      child: Text(
        editRoute ? 'Изменить поездку' : 'Создать поездку',
        style: AppTypography.nunito14Medium.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }

  void _onSubmitTap(BuildContext context) {
    CreateRouteScope.submit(context);
  }
}
