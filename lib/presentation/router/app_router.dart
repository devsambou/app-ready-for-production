import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../screens/city_detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/forecast_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

/// Application router using GoRouter.
/// Strict constraint respected: only primitive values (city names) are passed via extra.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/detail',
      name: 'detail',
      builder: (BuildContext context, GoRouterState state) {
        final cityName = (state.extra as String?) ?? AppConstants.defaultCity;
        return CityDetailScreen(cityName: cityName);
      },
    ),
    GoRoute(
      path: '/forecast',
      name: 'forecast',
      builder: (BuildContext context, GoRouterState state) {
        final cityName = (state.extra as String?) ?? AppConstants.defaultCity;
        return ForecastScreen(cityName: cityName);
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (BuildContext context, GoRouterState state) {
        return const FavoritesScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
  ],
);
