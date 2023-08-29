import 'package:flutter/material.dart';
import 'package:weather_app/ui/pages/home_page/home_page.dart';
import 'package:weather_app/ui/pages/search_page/search_page.dart';
import 'package:weather_app/ui/routes/app_routes.dart';

class AppNavigator {
  static String initRoute = AppRoutes.home;

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.home: (_) => const HomePage(),
      AppRoutes.search: (_) => const SearchPage(),
    };
  }
}
