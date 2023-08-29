import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/resources/app_icons.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:weather_app/ui/theme/app_style.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return SizedBox(
      height: 340,
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 160,
        ),
        itemBuilder: (contex, i) {
          return SizedBox(
            width: 180,
            // height: 160,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: AppColors.sevenDaysColor.withOpacity(0.5),
              child: Center(
                child: ListTile(
                  leading: SvgPicture.asset(
                    GridIcons.gridIcons[i],
                  ),
                  title: Text(
                    '${model.setValues(i)} ${GridUnits.gridIcons[i]}',
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    GridDescription.gridDesc[i],
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 10,
                      color: AppColors.darBlueColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridIcons {
  static List<String> gridIcons = [
    AppIcons.windSpeed,
    AppIcons.thermometer,
    AppIcons.raindrops,
    AppIcons.glasses,
  ];
}

class GridUnits {
  static List<String> gridIcons = [
    'км/ч',
    '°',
    '%',
    'км',
  ];
}

class GridDescription {
  static List<String> gridDesc = [
    'Скорость ветра',
    'Ощущается',
    'Влажность',
    'Видимость',
  ];
}
