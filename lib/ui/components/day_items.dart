import 'package:flutter/material.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:weather_app/ui/theme/app_style.dart';

class DayItems extends StatelessWidget {
  const DayItems({
    super.key,
    required this.weekday,
    required this.daylyIcon,
    this.dayTemp = 0,
    this.nightTemp = 0,
  });
  final String weekday, daylyIcon;
  final double dayTemp, nightTemp;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            weekday,
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darBlueColor,
            ),
          ),
        ),
        Image.network(
          daylyIcon,
          width: 30,
          height: 30,
        ),
        Expanded(
          flex: 2,
          child: Text(
            '$dayTemp℃',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darBlueColor,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '$nightTemp℃',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle,
          ),
        ),
      ],
    );
  }
}
