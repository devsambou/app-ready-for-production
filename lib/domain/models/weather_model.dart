import 'package:equatable/equatable.dart';

/// Domain entity representing current weather conditions for a city.
class WeatherModel extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime dateTime;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherList = (json['weather'] as List<dynamic>?) ?? [];
    final firstWeather = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final main = (json['main'] as Map<String, dynamic>?) ?? {};
    final wind = (json['wind'] as Map<String, dynamic>?) ?? {};
    final sys = (json['sys'] as Map<String, dynamic>?) ?? {};

    return WeatherModel(
      cityName: (json['name'] as String?) ?? '',
      country: (sys['country'] as String?) ?? '',
      temperature: ((main['temp'] as num?) ?? 0).toDouble(),
      feelsLike: ((main['feels_like'] as num?) ?? 0).toDouble(),
      tempMin: ((main['temp_min'] as num?) ?? 0).toDouble(),
      tempMax: ((main['temp_max'] as num?) ?? 0).toDouble(),
      humidity: ((main['humidity'] as num?) ?? 0).toInt(),
      pressure: ((main['pressure'] as num?) ?? 0).toInt(),
      windSpeed: ((wind['speed'] as num?) ?? 0).toDouble(),
      description: (firstWeather['description'] as String?) ?? 'Unknown',
      icon: (firstWeather['icon'] as String?) ?? '01d',
      dateTime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((json['dt'] as num).toInt()) * 1000,
              isUtc: true)
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        cityName,
        country,
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        humidity,
        pressure,
        windSpeed,
        description,
        icon,
        dateTime,
      ];
}
