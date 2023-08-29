import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/api/api.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/models/coord.dart';
import 'package:weather_app/domain/models/weather_model.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class WeatherProvider extends ChangeNotifier {
  //хранение координат
  Coord? coords;

  //Хранение данных о погоде
  WeatherData? weatherData;

  //Хранение текущих данных о погоде
  Current? current;

  //контроллер для поиска
  final searchController = TextEditingController();

  final pref = SharedPreferences.getInstance();
  String currentCity = 'Tashkent';

  Future<WeatherData?> setUp({String? cityName}) async {
    cityName = (await pref).getString('city');
    // (await pref).clear();
    coords = await Api.getCoords(cityName: cityName ?? currentCity);
    weatherData = await Api.getWeather(coords);
    current = weatherData?.current;
    setCurrentTime();
    setCurrentTemp();
    setSevenDays();
    getCurrentCity();

    return weatherData;
  }

  //получение текущего города из SharedPreferences
  Future<String> getCurrentCity() async {
    currentCity = capitalize((await pref).getString('city') ?? currentCity);
    return currentCity;
  }

  //изменение заднего фона

  String? currentBg;
  String setBg() {
    int id = current?.weather?[0].id ?? -1;
    if (id == -1 || current?.sunset == null || current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }
    try {
      //
      if (current?.sunset < current?.dt) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowNight;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogNight;
        } else if (id == 800) {
          currentBg = AppBg.shinyNight;
          AppColors.darBlueColor = AppColors.whiteColor;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyNight;
          AppColors.darBlueColor = AppColors.whiteColor;
        }
      } else {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowDay;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogDay;
        } else if (id == 800) {
          currentBg = AppBg.shinyDay;
          // AppColors.shinyColor = const Color(0xFFEC6E4C);
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyDay;
          // AppColors.shinyColor = const Color(0xFFEC6E4C);
        }
      }
    } catch (e) {
      return AppBg.shinyDay;
    }
    return currentBg ?? AppBg.shinyDay;
  }

  //текущее время
  String? currentTime;

  String setCurrentTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    // print(getTime);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);

    currentTime = DateFormat('HH:mm a').format(setTime);

    return currentTime ?? 'Error';
  }

  //текущий статус погоды
  String currentStatus = '';

  String getCurrentStatus() {
    currentStatus = current?.weather?[0].description ?? 'Ошибка';
    return capitalize(currentStatus);
  }

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  //http://openweathermap.org/img/wn/

  final String _iconUrlPath = 'http://openweathermap.org/img/wn/';

  //текущая иконка
  String iconData() {
    return '$_iconUrlPath${current?.weather?[0].icon}.png';
  }

  //обработка текущей температуры
  int kelvin = -273;
  double currentTemp = 0;

  double setCurrentTemp() {
    currentTemp = ((current?.temp ?? -kelvin) + kelvin).roundToDouble();
    return currentTemp;
  }

  //макисмальная текущая температура
  double maxTemp = 0;

  double setMaxTemp() {
    maxTemp = ((weatherData?.daily?[0].temp?.max ?? -kelvin) + kelvin)
        .roundToDouble();
    return maxTemp;
  }

  //минимальная текущая температура
  double minTemp = 0;

  double setMinTemp() {
    minTemp = ((weatherData?.daily?[0].temp?.min ?? -kelvin) + kelvin)
        .roundToDouble();
    return minTemp;
  }

  //установка дней недели

  final List<String> date = [];
  List<Daily> daily = [];

  void setSevenDays() {
    daily = weatherData!.daily!;
    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }

      if (i == 0) {
        date.add('Сегодня');
      } else {
        var timeNum = daily[i].dt * 1000;
        var itemdate = DateTime.fromMillisecondsSinceEpoch(timeNum);
        date.add(capitalize(DateFormat('EEEE', 'ru').format(itemdate)));
      }
    }
  }

  //иконки на неделю
  String setDailyIcons(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$_iconUrlPath$getIcon.png';
    return setIcon;
  }

  //дневная   температура на каждый день
  double dailyTemp = 0;

  double setDailyTemp(int index) {
    dailyTemp = ((weatherData?.daily?[index].temp?.day ?? -kelvin) + kelvin)
        .roundToDouble();
    return dailyTemp;
  }

  //ночная  температура на каждый день
  double nightTemp = 0;

  double setNightTemp(int index) {
    nightTemp = ((weatherData?.daily?[index].temp?.night ?? -kelvin) + kelvin)
        .roundToDouble();
    return nightTemp;
  }

  //погодные данные

  final List<dynamic> weatherValue = [];

  dynamic setValues(int index) {
    weatherValue.add((current?.windSpeed ?? 0));
    weatherValue
        .add(((current?.feelsLike ?? -kelvin) + kelvin).roundToDouble());
    weatherValue.add((current?.humidity ?? 0) / 1);
    weatherValue.add((current?.visibility ?? 0) / 1000);
    return weatherValue[index];
  }

  //время восхода
  String sunRise = '';
  String setCurrentSunRise() {
    final getSunTime =
        (current?.sunrise ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunRise = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunRise = DateFormat('HH:mm a').format(setSunRise);
    return sunRise;
  }

  //время заката
  String sunSet = '';
  String setCurrentSunSet() {
    final getSunTime =
        (current?.sunset ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunSet = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunSet = DateFormat('HH:mm a').format(setSunSet);
    return sunSet;
  }

  var box = Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox);

  //Добавление в избранное
  Future<void> setFavorite(BuildContext context, {String? cityName}) async {
    box
        .add(
          FavoriteHistory(
            currentCity: cityName ?? 'Error',
            currentZone: weatherData?.timezone ?? 'Error',
            bg: currentBg ?? AppBg.shinyDay,
            // icon: iconData(),
            // currentTemp: currentTemp,
          ),
        )
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.sevenDaysColor,
              content: Text(
                'Город $cityName добавлен в избранное',
              ),
            ),
          ),
        );
  }

  //удаление из избранных
  Future<void> deleteFavorite(int index) async {
    box.deleteAt(index);
  }

  //установка текущего города

  Future<void> setCurrentCity(BuildContext context, {String? cityName}) async {
    if (searchController.text != '') {
      cityName = searchController.text;

      (await pref).setString('city', cityName);
      await setUp(cityName: (await pref).getString('city'))
          .then((value) => Navigator.pop(context))
          .then((value) => searchController.clear());
      notifyListeners();
    }
  }
}
