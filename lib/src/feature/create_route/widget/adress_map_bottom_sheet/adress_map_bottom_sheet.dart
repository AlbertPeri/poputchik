import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/adress_map/adress_map_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/scope/adress_map_scope.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:companion/src/feature/create_route/widget/adress_map_bottom_sheet/confirm_button/confirm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdressMapBottomSheet extends StatelessWidget {
  const AdressMapBottomSheet({
    required this.adressType,
    required this.onTap,
    required this.onPop,
    super.key,
  });

  final AdressType adressType;
  final void Function() onTap;
  final void Function() onPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => onPop,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                adressType == AdressType.departure
                    ? 'Точка отправления'
                    : 'Точка прибытия',
                style: AppTypography.nunito20Medium.copyWith(
                  color: AppColors.textBlackColor,
                ),
              ),
              const SizedBox(height: 14),
              BlocBuilder<AdressMapBloc, AdressMapState>(
                builder: (context, state) {
                  final text = AdressMapScope.buttonText(context);
                  final adressIsLoaded = AdressMapScope.adressIsLoaded(context);
                  final bottonIsActive =
                      AdressMapScope.geoDataOrNull(context) != null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RoundedButton(
                        color: AppColors.white,
                        overlayColor: AppColors.blackOverlay,
                        borderRadius: 24,
                        padding: const EdgeInsets.symmetric(
                          vertical: 21.5,
                          horizontal: 10,
                        ),
                        onTap: onTap,
                        child: Row(
                          children: [
                            Assets.icons.icPathCircle.svg(width: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                text,
                                style: AppTypography.nunito14Regular.copyWith(
                                  color: adressIsLoaded
                                      ? null
                                      : AppColors.textGreyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ConfirmButton(
                        onTap: bottonIsActive
                            ? () => _onConfirmButtonTap(
                                  context,
                                  state,
                                )
                            : null,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirmButtonTap(BuildContext context, AdressMapState state) {
    final geoDataOrNull = AdressMapScope.geoDataOrNull(context);
    if (geoDataOrNull == null) return;

    CreateRouteScope.changeData(
      context,
      data: geoDataOrNull,
      adressType: adressType,
    );
    onPop();
  }
}
