import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/components/current_region_item.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
// import 'package:weather_app/ui/resources/app_icons.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable:
              Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox).listenable(),
          builder: (context, value, _) {
            return ListView.separated(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, i) {
                return FavoriteCard(
                  index: i,
                  value: value,
                );
              },
              separatorBuilder: (context, i) => const SizedBox(height: 10),
              itemCount: value.length,
            );
          }),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.index,
    required this.value,
  });

  final int index;
  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            value.getAt(index)?.bg ?? AppBg.shinyDay,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CurrentTimeZone(
            currentCity: value.getAt(index)?.currentCity ?? 'Error',
            currentZone: model.weatherData?.timezone,
          ),
          CurrentRegionTemp(
            icon: value.getAt(index)?.icon ?? '',
            currentTemp: value.getAt(index)?.currentTemp ?? 0,
          ),
          IconButton(
            onPressed: () {
              model.deleteFavorite(index);
            },
            icon: Icon(
              Icons.delete,
              color: AppColors.redColor,
            ),
          ),
        ],
      ),
    );
  }
}
