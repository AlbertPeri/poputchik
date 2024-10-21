import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/utils/utils.dart';
import 'package:flutter/material.dart';

class PersonInfoBlock extends StatelessWidget {
  const PersonInfoBlock({
    required this.personName,
    required this.phoneNumber,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  final String personName;

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          foregroundImage: avatarUrl != null
              ? NetworkImage(
                  avatarUrl!,
                )
              : null,
          child: const Icon(
            Icons.person,
            size: 64,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          personName,
          style: AppTypography.nunitoSans16Bold,
        ),
        if (phoneNumber.isNotEmpty) ...[
          Text(
            TextInputFormatterX.phoneMask.maskText(phoneNumber.substring(1)),
            style: AppTypography.nunitoSans16Regular.copyWith(
              color: AppColors.black3.withOpacity(0.6),
            ),
          ),
        ] else ...[
          Text(
            'Номер телефона скрыт',
            style: AppTypography.nunitoSans16Regular.copyWith(
              color: AppColors.black3.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
