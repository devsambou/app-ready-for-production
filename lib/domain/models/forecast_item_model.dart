import 'package:equatable/equatable.dart';

/// Represents a single 3-hour forecast point from OpenWeatherMap.
class ForecastItemModel extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;

  const ForecastItemModel({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    final weatherList = (json['weather'] as List<dynamic>?) ?? [];
    final firstWeather = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final main = (json['main'] as Map<String, dynamic>?) ?? {};
    final wind = (json['wind'] as Map<String, dynamic>?) ?? {};

    return ForecastItemModel(
      dateTime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((json['dt'] as num).toInt()) * 1000,
              isUtc: true)
          : DateTime.now(),
      temperature: ((main['temp'] as num?) ?? 0).toDouble(),
      tempMin: ((main['temp_min'] as num?) ?? 0).toDouble(),
      tempMax: ((main['temp_max'] as num?) ?? 0).toDouble(),
      humidity: ((main['humidity'] as num?) ?? 0).toInt(),
      windSpeed: ((wind['speed'] as num?) ?? 0).toDouble(),
      description: (firstWeather['description'] as String?) ?? '',
      icon: (firstWeather['icon'] as String?) ?? '01d',
    );
  }

  @override
  List<Object?> get props => [
        dateTime,
        temperature,
        tempMin,
        tempMax,
        humidity,
        windSpeed,
        description,
        icon,
      ];
}
