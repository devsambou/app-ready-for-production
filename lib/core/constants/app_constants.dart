/// Application constants, OpenWeatherMap endpoints and defaults.
abstract final class AppConstants {
  static const String appName = 'WeatherApp Pro';
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  static const String openWeatherIconBaseUrl =
      'https://openweathermap.org/img/wn';

  static const String defaultCity = 'Paris';
  static const String hiveFavoritesBox = 'favorites_box';
  static const String hiveSettingsBox = 'settings_box';

  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;

  static String iconUrl(String iconCode) =>
      '$openWeatherIconBaseUrl/$iconCode@2x.png';
}
