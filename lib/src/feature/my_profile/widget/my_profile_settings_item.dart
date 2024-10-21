import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileSettingsItem extends StatelessWidget {
  const MyProfileSettingsItem({
    required this.title,
    required this.icon,
    super.key,
    this.onTap,
    this.trailing,
  });

  final String title;

  final SvgPicture icon;

  final void Function()? onTap;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.fromLTRB(10, 8, 20, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'NunitoSans',
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.chevron_right_rounded,
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}
