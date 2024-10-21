import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:render_metrics/render_metrics.dart';

const _avatarRadius = 50.0;

/// {@template profile_avatar}
///  Отображения аватара
/// {@endtemplate}
class MyProfileAvatar extends StatefulWidget {
  /// {@macro profile_avatar}
  const MyProfileAvatar({super.key, this.avatarUrl});

  final String? avatarUrl;

  @override
  State<MyProfileAvatar> createState() => _MyProfileAvatarState();
}

class _MyProfileAvatarState extends State<MyProfileAvatar> {
  static const _avatarId = 'avatar';
  late final RenderParametersManager<dynamic> renderManager;

  @override
  void initState() {
    renderManager = RenderParametersManager<dynamic>();
    super.initState();
  }

  Future<void> showContextMenu(
    BuildContext context,
    TapDownDetails details,
  ) async {
    const colorFilter = ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn);
    const divider = SizedBox(width: 10);
    const padding = EdgeInsets.only(left: 18);
    const menuWidth = 183.0;

    final data = renderManager.getRenderData(_avatarId);
    final center = data?.center.x ?? 0;
    final height = data?.yTop ?? 0;
    final widthOffset =
        center - _avatarRadius / 2 - (menuWidth - _avatarRadius * 2) / 2;

    await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      constraints: const BoxConstraints(maxWidth: menuWidth),
      elevation: 0,
      color: AppColors.accentColor,
      position: RelativeRect.fromLTRB(
        widthOffset,
        height + 100 + 6,
        widthOffset,
        0,
      ),
      items: [
        PopupMenuItem(
          padding: padding,
          value: 'favorites',
          child: Row(
            children: [
              Assets.icons.icProfile.svg(colorFilter: colorFilter),
              divider,
              const Text('Открыть фото', style: AppTypography.nunito14Regular),
            ],
          ),
        ),
        PopupMenuItem(
          padding: padding.copyWith(right: 18),
          value: 'comment',
          child: Row(
            children: [
              Assets.icons.icEdit.svg(height: 24, width: 24),
              divider,
              const Text('Изменить фото', style: AppTypography.nunito14Regular),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'hide',
          padding: padding,
          child: Row(
            children: [
              Assets.icons.icDelete.svg(height: 24, width: 24),
              divider,
              const Text('Удалить фото', style: AppTypography.nunito14Regular),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.avatarUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(_avatarRadius),
      child: GestureDetector(
        // onTapDown: (details) => showContextMenu(context, details),
        child: RenderMetricsObject(
          id: _avatarId,
          manager: renderManager,
          child: avatarUrl != null
              ? SizedBox.square(
                  dimension: _avatarRadius * 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          avatarUrl,
                        ),
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  onForegroundImageError: (exception, stackTrace) => const Icon(
                    Icons.person,
                    size: 64,
                  ),
                  radius: _avatarRadius,
                  foregroundColor: AppColors.darkPurple,
                  foregroundImage: avatarUrl != null
                      ? NetworkImage(
                          avatarUrl,
                        )
                      : null,
                  child: const Icon(
                    Icons.person,
                    size: 64,
                  ),
                ),
        ),
      ),
    );
  }
}
