import 'package:companion/src/assets/colors/app_colors.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/create_route/create_route_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:companion/src/feature/create_route/widget/route_info_bottom_sheet/adress_button/adress_button.dart';
import 'package:companion/src/feature/create_route/widget/route_info_bottom_sheet/date_button/date_button.dart';
import 'package:companion/src/feature/create_route/widget/route_info_bottom_sheet/people_amount_button/people_amount_button.dart';
import 'package:companion/src/feature/create_route/widget/route_info_bottom_sheet/submit_button/submit_button.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteInfoBottomSheet extends StatelessWidget {
  const RouteInfoBottomSheet({
    required this.adressModal,
    required this.editRoute,
    super.key,
  });

  final void Function(BuildContext, AdressType) adressModal;
  final bool editRoute;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: BlocBuilder<CreateRouteBloc, CreateRouteState>(
            buildWhen: (pr, cu) => cu is Loaded,
            builder: (context, state) {
              if (state is! Loaded) {
                return const Loader();
              }
              final (depText, depIsLoaded) = _getTextAndLoadedValue(
                state.departureData,
                AdressType.departure,
              );
              final (arrText, arrIsLoaded) = _getTextAndLoadedValue(
                state.arrivalData,
                AdressType.arrival,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdressButton(
                    title: depText,
                    isLoaded: depIsLoaded,
                    adressType: AdressType.departure,
                    adressModal: adressModal,
                  ),
                  const SizedBox(height: 10),
                  AdressButton(
                    title: arrText,
                    isLoaded: arrIsLoaded,
                    adressType: AdressType.arrival,
                    adressModal: adressModal,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DateButton(
                          departureDate: state.departureDate,
                        ),
                      ),
                      const SizedBox(width: 6),
                      PeopleAmountButton(personCount: state.peopleAmount),
                    ],
                  ),
                  const SizedBox(height: 13),
                  SubmitButton(state: state, editRoute: editRoute),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  (String, bool) _getTextAndLoadedValue(AddressGeoData? data, AdressType type) {
    if (data == null) {
      return switch (type) {
        AdressType.departure => ('Откуда поедете?', false),
        AdressType.arrival => ('Куда поедете?', false),
      };
    }
    if (data.address == null) return ('Загрузка...', false);
    return (data.address!, true);
  }
}
