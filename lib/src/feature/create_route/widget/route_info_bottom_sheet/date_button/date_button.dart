import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  const DateButton({
    required this.departureDate,
    super.key,
  });

  final DateTime? departureDate;

  @override
  Widget build(BuildContext context) {
    final text = departureDate == null
        ? 'Выберите дату'
        : DateFormat.yMd('ru').add_jm().format(
              departureDate!,
            );

    return RoundedButton(
      color: AppColors.white,
      borderRadius: 24,
      overlayColor: AppColors.blackOverlay,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 21),
      child: Row(
        children: [
          Assets.icons.icCalendar.svg(
            colorFilter: const ColorFilter.mode(
              AppColors.iconColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: AppTypography.nunito14Regular.copyWith(
              color: departureDate != null ? null : AppColors.textGreyColor,
            ),
          ),
        ],
      ),
      onTap: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final dateNow = DateTime.now();
    final selectedDate = await showDatePicker(
      fieldHintText: 'Введите дату поездки',
      helpText: 'Выберите дату поездки',
      fieldLabelText: '',
      context: context,
      firstDate: dateNow,
      lastDate: dateNow.add(const Duration(days: 90)),
    );
    if (!context.mounted || selectedDate == null) return;
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (!context.mounted || selectedTime == null) return;

    CreateRouteScope.changeDepartureDate(
      context,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );
  }
}
