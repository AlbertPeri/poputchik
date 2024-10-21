import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/feature/create_route/enum/adress_type.dart';
import 'package:companion/src/feature/create_route/model/address_geo_data/address_geo_data.dart';
import 'package:companion/src/feature/create_route/model/address_list_data/address_list_data.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdressItem extends StatelessWidget {
  const AdressItem({
    required this.adressListData,
    required this.adressType,
    super.key,
  });

  final AddressListData adressListData;
  final AdressType adressType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Assets.icons.icLocationGrey.svg(),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adressListData.title!,
                      style: AppTypography.nunito14Regular.copyWith(
                        color: AppColors.textBlackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (adressListData.subtitle != null)
                      Text(
                        adressListData.subtitle!,
                        style: AppTypography.nunito10Regular.copyWith(
                          color: AppColors.textGreyColor,
                          height: 12.4 / 10,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    CreateRouteScope.changeData(
      context,
      data: AddressGeoData(address: adressListData.full),
      adressType: adressType,
    );
    context.pop();
  }
}
