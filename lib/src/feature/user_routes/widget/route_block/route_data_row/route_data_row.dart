import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/widget/widget.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:intl/intl.dart';

class RouteDataRow extends StatelessWidget {
  const RouteDataRow({
    required this.route,
    super.key,
  });

  final Route route;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Assets.icons.icPathCircle.svg(),
                  const SizedBox(height: 4),
                  Expanded(
                    child: CustomPaint(
                      size: const Size(1, 28),
                      painter: DashedLinePainter(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Assets.icons.icPathCircle.svg(),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        route.startPlace,
                        style: AppTypography.nunito20Medium,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      route.endPlace,
                      style: AppTypography.nunito20Medium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Время',
          style: AppTypography.nunito14Medium.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 6),
        Text.rich(
          style: AppTypography.nunito28SemiBold,
          TextSpan(
            text: DateFormat(' H:mmч, dd MMMM', 'ru').format(route.date),
          ),
        ),
      ],
    );
  }
}
