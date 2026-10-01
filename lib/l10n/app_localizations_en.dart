// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WeatherApp Pro';

  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navSettings => 'Settings';

  @override
  String get navForecast => 'Forecast';

  @override
  String get searchHint => 'Search city (e.g. Paris, Tokyo)...';

  @override
  String get searchLabel => 'City search input';

  @override
  String get searchAction => 'Search';

  @override
  String get defaultCity => 'Paris';

  @override
  String get favoritesTitle => 'Saved Cities';

  @override
  String get noFavorites =>
      'No favorite cities yet. Add one from the detail screen!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get unit => 'Temperature Unit';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get weatherDetails => 'Weather Details';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind speed';

  @override
  String get pressure => 'Pressure';

  @override
  String get forecastTitle => '5-Day Forecast';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get favoriteAdded => 'City added to favorites';

  @override
  String get favoriteRemoved => 'City removed from favorites';

  @override
  String get retry => 'Retry';

  @override
  String get errorOccurred => 'An error occurred while loading weather data.';

  @override
  String get cityNotFound => 'City not found. Please verify spelling.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get viewForecast => 'View 5-day forecast';

  @override
  String get lastUpdated => 'Updated just now';
}
