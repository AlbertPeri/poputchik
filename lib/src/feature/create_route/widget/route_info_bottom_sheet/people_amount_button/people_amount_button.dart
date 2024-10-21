import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeopleAmountButton extends StatelessWidget {
  const PeopleAmountButton({
    required this.personCount,
    super.key,
  });

  final int personCount;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      color: AppColors.white,
      borderRadius: 20,
      overlayColor: AppColors.blackOverlay,
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 24.5),
      child: Row(
        children: [
          Assets.icons.icProfileGrey.svg(),
          const SizedBox(width: 7),
          Text(personCount.toString(), style: AppTypography.nunito14Regular),
        ],
      ),
      onTap: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final selectedCount = CreateRouteScope.peopleAmountOrNull(context);
    if (selectedCount == null) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      constraints: const BoxConstraints(
        maxHeight: 250,
      ),
      builder: (context) {
        return SafeArea(
          child: CupertinoPicker(
            itemExtent: 50,
            scrollController: FixedExtentScrollController(
              initialItem: selectedCount - 1,
            ),
            onSelectedItemChanged: (value) {
              CreateRouteScope.changePersonCount(context, value + 1);
            },
            children: List<Widget>.generate(4, (index) {
              final ending = index == 0 ? 'попутчик' : 'попутчика';
              return Center(
                child: Text(
                  '${index + 1} $ending',
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
