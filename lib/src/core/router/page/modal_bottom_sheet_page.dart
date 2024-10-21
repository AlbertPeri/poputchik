import 'package:companion/src/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// {@template modal_bottom_sheet_page}
/// Модальное окно
///{@endtemplate}
class ModalBottomSheetPage extends Page<Object?> {
  /// {@macro modal_bottom_sheet_page}
  const ModalBottomSheetPage({
    this.child,
    this.builder,
    this.showDragHandle = true,
    super.key,
    super.name,
    this.constraints,
    this.isDismissible = true,
    this.backgroundColor,
    this.withClose = true,
  });

  final Widget? child;

  final bool showDragHandle;

  final bool isDismissible;

  final Color? backgroundColor;

  final BoxConstraints? constraints;

  final bool withClose;

  final Widget Function(
    BuildContext context,
    ScrollController scrollController,
  )? builder;

  // ignore: sort_constructors_first
  factory ModalBottomSheetPage.scrollable({
    Widget Function(
      BuildContext context,
      ScrollController scrollController,
    )? builder,
    bool isDismissible = true,
  }) =>
      ModalBottomSheetPage(
        isDismissible: isDismissible,
        builder: builder,
      );

  static const roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  );

  @override
  Route<Object?> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      isDismissible: isDismissible,
      builder: (context) => builder != null
          ? DraggableScrollableSheet(
              builder: builder!,
              expand: false,
            )
          : Stack(
              children: [
                child!,
                if (showDragHandle && withClose)
                  Positioned(
                    right: 0,
                    top: -10,
                    child: CupertinoButton(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),
                      onPressed: context.pop,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
      backgroundColor:
          backgroundColor ?? context.theme.colorScheme.secondaryContainer,
      showDragHandle: showDragHandle,
      clipBehavior: Clip.antiAlias,
      settings: this,
      enableDrag: isDismissible,
      constraints: constraints,
      shape: roundedRectangleBorder,
      isScrollControlled: builder == null,
    );
  }
}
