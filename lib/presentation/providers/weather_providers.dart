import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/weather_dio_client.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/forecast_repository.dart';
import '../../data/repositories/weather_repository.dart';
import '../../domain/models/forecast_day_model.dart';
import '../../domain/models/weather_model.dart';
import '../../domain/repositories/forecast_repository_interface.dart';
import '../../domain/repositories/weather_repository_interface.dart';
import 'settings_provider.dart';

final weatherDioClientProvider = Provider<WeatherDioClient>((ref) {
  return WeatherDioClient();
});

final weatherRemoteDataSourceProvider =
    Provider<IWeatherRemoteDataSource>((ref) {
  final client = ref.watch(weatherDioClientProvider);
  return WeatherRemoteDataSource(client: client);
});

final weatherRepositoryProvider = Provider<IWeatherRepository>((ref) {
  final dataSource = ref.watch(weatherRemoteDataSourceProvider);
  return WeatherRepository(remoteDataSource: dataSource);
});

final forecastRepositoryProvider = Provider<IForecastRepository>((ref) {
  final dataSource = ref.watch(weatherRemoteDataSourceProvider);
  return ForecastRepository(remoteDataSource: dataSource);
});

/// Current search query in the search bar. Defaults to Paris.
final searchQueryProvider = StateProvider<String>((ref) {
  return AppConstants.defaultCity;
});

/// Fetches current weather for a city with the chosen temperature unit.
final currentWeatherProvider =
    FutureProvider.family<WeatherModel, String>((ref, cityName) async {
  final repository = ref.watch(weatherRepositoryProvider);
  final unit = ref.watch(settingsProvider.select((s) => s.unit));
  return repository.getCurrentWeather(cityName, units: unit);
});

/// Fetches 5-day daily aggregated forecast for a city with the chosen unit.
final forecastProvider = FutureProvider.family<List<ForecastDayModel>, String>(
    (ref, cityName) async {
  final repository = ref.watch(forecastRepositoryProvider);
  final unit = ref.watch(settingsProvider.select((s) => s.unit));
  return repository.getFiveDayForecast(cityName, units: unit);
});
