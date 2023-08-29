import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/components/day_items.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class WeekDayWidget extends StatelessWidget {
  const WeekDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: AppColors.sevenDaysColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return DayItems(
            weekday: context.watch<WeatherProvider>().date[i],
            daylyIcon: context.watch<WeatherProvider>().setDailyIcons(i),
            dayTemp: context.watch<WeatherProvider>().setDailyTemp(i),
            nightTemp: context.watch<WeatherProvider>().setNightTemp(i),
          );
        },
        separatorBuilder: (context, i) => const SizedBox(height: 16),
        itemCount: 7,
      ),
    );
  }
}
