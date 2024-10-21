import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_list_data/address_list_data.dart';
import 'package:companion/src/feature/create_route/widget/adresses_list_bottom_sheet/adresses_list/adress_item.dart';
import 'package:flutter/material.dart';

class AdressesList extends StatelessWidget {
  const AdressesList({
    required this.adressListData,
    required this.adressType,
    super.key,
  });

  final List<AddressListData> adressListData;
  final AdressType adressType;

  @override
  Widget build(BuildContext context) {
    if (adressListData.isEmpty) {
      return const Text('По вашему запросу не удалось ничего найти');
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: adressListData.length,
        itemBuilder: (context, index) => AdressItem(
          adressListData: adressListData[index],
          adressType: adressType,
        ),
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5),
              Divider(height: 0.5),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
