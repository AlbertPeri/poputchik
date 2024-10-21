import 'package:companion/src/assets/colors/app_colors.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/bloc/adresses_list/adresses_list_bloc.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/scope/adress_list_scope.dart';
import 'package:companion/src/feature/create_route/widget/adresses_list_bottom_sheet/adress_text_field/adress_text_field.dart';
import 'package:companion/src/feature/create_route/widget/adresses_list_bottom_sheet/adresses_list/adresses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdressesListBottomSheet extends StatefulWidget {
  const AdressesListBottomSheet({
    required this.adressType,
    required this.showMapButton,
    super.key,
  });

  final AdressType adressType;
  final bool showMapButton;

  @override
  State<AdressesListBottomSheet> createState() =>
      _AdressesListBottomSheetState();
}

class _AdressesListBottomSheetState extends State<AdressesListBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: AdressTextField(
                    controller: _controller,
                    adressType: widget.adressType,
                    showMapButton: widget.showMapButton,
                    onChanged: (value) => _onChanged(value, context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<AdressesListBloc, AdressesListState>(
            builder: (context, state) {
              return state.when(
                idle: () => const Expanded(
                  child: Center(child: Text('Введите адрес для поиска')),
                ),
                loading: () => const Expanded(child: Center(child: Loader())),
                error: (message) => Expanded(
                  child: Center(
                    child: Text(message),
                  ),
                ),
                loaded: (adresses) => AdressesList(
                  adressListData: adresses,
                  adressType: widget.adressType,
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  void _onChanged(String value, BuildContext context) {
    if (value.isEmpty) return;
    AdressListScope.searchByQuery(context, value);
  }
}
