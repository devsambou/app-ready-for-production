import '../../domain/models/forecast_day_model.dart';
import '../../domain/models/forecast_item_model.dart';
import '../../domain/repositories/forecast_repository_interface.dart';
import '../datasources/weather_remote_data_source.dart';

/// Concrete implementation of [IForecastRepository].
/// Handles 3-hour raw forecasts and day-by-day aggregation logic.
class ForecastRepository implements IForecastRepository {
  final IWeatherRemoteDataSource remoteDataSource;

  ForecastRepository({required this.remoteDataSource});

  @override
  Future<List<ForecastItemModel>> getRawHourlyForecast(String cityName,
      {String units = 'metric'}) async {
    final rawJson =
        await remoteDataSource.fetchForecast(cityName, units: units);
    final list = (rawJson['list'] as List<dynamic>?) ?? [];
    return list
        .map((item) => ForecastItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ForecastDayModel>> getFiveDayForecast(String cityName,
      {String units = 'metric'}) async {
    final hourlyItems = await getRawHourlyForecast(cityName, units: units);

    // Group forecast items by calendar day
    final Map<String, List<ForecastItemModel>> groupedByDay = {};

    for (final item in hourlyItems) {
      final key =
          '${item.dateTime.year}-${item.dateTime.month.toString().padLeft(2, '0')}-${item.dateTime.day.toString().padLeft(2, '0')}';
      groupedByDay.putIfAbsent(key, () => []).add(item);
    }

    final List<ForecastDayModel> dailyForecasts = [];
    groupedByDay.forEach((dayKey, items) {
      if (items.isNotEmpty) {
        dailyForecasts
            .add(ForecastDayModel.fromHourlyItems(items.first.dateTime, items));
      }
    });

    // Return up to 5 days
    return dailyForecasts.take(5).toList();
  }
}
