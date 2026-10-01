import '../models/weather_model.dart';

/// Contract for fetching current weather data.
abstract class IWeatherRepository {
  Future<WeatherModel> getCurrentWeather(String cityName,
      {String units = 'metric'});
}
