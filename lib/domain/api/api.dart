import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/domain/models/coord.dart';
import 'package:weather_app/domain/models/weather_model.dart';

abstract class Api {
  static final apiKey = dotenv.get('API_KEY');

  // Ссылка для получения координат
//https://api.openweathermap.org/data/2.5/weather?q=London&appid=8a00668c6b556cefecfd7888df2a5aff

  static Future<Coord> getCoords({String cityName = 'Tashkent'}) async {
    final dio = Dio();
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&lang=ru');

    try {
      final coords = Coord.fromJson(response.data);
      return coords;
    } catch (e) {
      final coords = Coord.fromJson(response.data);
      return coords;
    }
  }

  // Ссылка для получения погоды
//https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&exclude=hourly,minutely&appid=706968d3152b1e9db4c1426a661b8726

  static Future<WeatherData?> getWeather(Coord? coord) async {
    if (coord != null) {
      final dio = Dio();
      final lat = coord.lat.toString();
      final lon = coord.lon.toString();
      print(lon);
      
      final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely&appid=$apiKey&lang=ru');
      print(response.statusCode);
      final weatherData = WeatherData.fromJson(response.data);
      return weatherData;
    }
    return null;
  }
}
