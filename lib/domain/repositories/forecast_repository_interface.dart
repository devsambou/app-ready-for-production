import '../models/forecast_day_model.dart';
import '../models/forecast_item_model.dart';

/// Contract for fetching forecast data and aggregating 3h slots into 5-day forecasts.
abstract class IForecastRepository {
  Future<List<ForecastItemModel>> getRawHourlyForecast(String cityName,
      {String units = 'metric'});
  Future<List<ForecastDayModel>> getFiveDayForecast(String cityName,
      {String units = 'metric'});
}
