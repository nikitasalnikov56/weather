import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/components/current_weather_status.dart';
import 'package:weather_app/ui/components/grid_widget.dart';
import 'package:weather_app/ui/components/max_min_temp.dart';
import 'package:weather_app/ui/components/sunset_sunrise.dart';
import 'package:weather_app/ui/components/weekday_widget.dart';
import 'package:weather_app/ui/routes/app_routes.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:weather_app/ui/theme/app_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return FutureBuilder(
        future: model.setUp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ScaffoldWidget(model: model);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
    required this.model,
  });

  final WeatherProvider model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextButton.icon(
          onPressed: () {
            model.setFavorite(context, cityName: model.weatherData?.timezone);
          },
          icon: Icon(
            Icons.location_on,
            color: AppColors.redColor,
          ),
          label: Text(
            '${model.weatherData?.timezone}',
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darBlueColor,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
            icon: Icon(
              Icons.add,
              color: AppColors.darBlueColor,
            ),
          ),
        ],
      ),
      body: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            model.setBg(),
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          Text(
            '${model.date.last} ${model.currentTime}',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darBlueColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 36),
          const CurrentWeatherStatus(),
          const SizedBox(height: 28),
          //alt + 0176
          Text(
            '${model.currentTemp}℃',
            textAlign: TextAlign.center,
            style: AppStyle.fontStyle.copyWith(
              fontSize: 90,
              color: AppColors.darBlueColor,
            ),
          ),
          const SizedBox(height: 18),
          const MaxMinTemp(),
          const SizedBox(height: 40),
          const WeekDayWidget(),
          const SizedBox(height: 28),
          const GridWidget(),
          const SizedBox(height: 30),
          const SunSetSunRise(),
        ],
      ),
    );
  }
}
