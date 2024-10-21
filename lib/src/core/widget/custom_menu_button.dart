import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    required this.icon,
    required this.items,
    super.key,
    this.diameter = 40,
    this.color = AppColors.grey,
    this.padding = 11,
  });

  final Widget icon;
  final List<PopupMenuItemModel> items;
  final double diameter;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showMenu(context, items);
      },
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.square(diameter),
        //backgroundColor: color,
        //highlightColor: color.getSplashColor,
      ),
      padding: EdgeInsets.all(padding),
      icon: icon,
    );
  }

  Future<void> _showMenu(
    BuildContext context,
    List<PopupMenuItemModel> items,
  ) async {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    await showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height + 10,
        0,
        0, //offset.dy + renderBox.size.height + diameter,
      ),
      color: AppColors.textBlackColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      items: items.map(_createMenuItem).toList(),
    );
  }

  PopupMenuItem<void> _createMenuItem(PopupMenuItemModel item) =>
      PopupMenuItem<void>(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        onTap: item.onTap,
        child: Center(
          child: Text(
            item.title,
            style:
                AppTypography.nunito14Regular.copyWith(color: AppColors.white),
          ),
        ),
      );
}

class PopupMenuItemModel {
  const PopupMenuItemModel({
    required this.onTap,
    required this.title,
  });

  final VoidCallback onTap;
  final String title;
}
