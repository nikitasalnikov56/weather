import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/resources/app_icons.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:weather_app/ui/theme/app_style.dart';

class SunSetSunRise extends StatelessWidget {
  const SunSetSunRise({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sevenDaysColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RowItemWidget(
            icon: AppIcons.sunrise,
            text: 'Восход ${model.setCurrentSunRise()} ',
          ),
          RowItemWidget(
            icon: AppIcons.sunset,
            text: 'Закат ${model.setCurrentSunSet()} ',
          ),
        ],
      ),
    );
  }
}

class RowItemWidget extends StatelessWidget {
  const RowItemWidget({
    super.key,
    required this.icon,
    required this.text,
  });
  final String icon, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          color: AppColors.darBlueColor,
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: AppStyle.fontStyle.copyWith(fontSize: 16),
        )
      ],
    );
  }
}
