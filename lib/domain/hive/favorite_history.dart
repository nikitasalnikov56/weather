import 'package:hive_flutter/adapters.dart';

part 'favorite_history.g.dart';
//flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 0)
class FavoriteHistory {
  @HiveField(0)
  String currentCity;

  @HiveField(1)
  String currentZone;

  @HiveField(2)
  String icon;

  @HiveField(3)
  double currentTemp;

  @HiveField(4)
  String bg;

  FavoriteHistory({
    this.currentCity = '',
    this.currentZone = '',
    this.icon = '',
    this.currentTemp = 0,
    this.bg = '',
  });
}
