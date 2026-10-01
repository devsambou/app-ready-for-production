import 'package:equatable/equatable.dart';
import 'forecast_item_model.dart';

/// Aggregated daily forecast representing a full day from multiple 3-hour snapshots.
class ForecastDayModel extends Equatable {
  final DateTime date;
  final double dayTemp;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;
  final List<ForecastItemModel> hourlyItems;

  const ForecastDayModel({
    required this.date,
    required this.dayTemp,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.hourlyItems,
  });

  /// Factory helper that computes daily aggregation from 3h forecast items of the same calendar day.
  factory ForecastDayModel.fromHourlyItems(
      DateTime date, List<ForecastItemModel> items) {
    if (items.isEmpty) {
      return ForecastDayModel(
        date: date,
        dayTemp: 0,
        minTemp: 0,
        maxTemp: 0,
        description: '',
        icon: '01d',
        hourlyItems: const [],
      );
    }

    double min = items.first.tempMin;
    double max = items.first.tempMax;
    double sumTemp = 0;

    for (final item in items) {
      if (item.tempMin < min) min = item.tempMin;
      if (item.tempMax > max) max = item.tempMax;
      sumTemp += item.temperature;
    }

    final avgTemp = sumTemp / items.length;
    // Pick the midday item (closest to 12:00 UTC) for icon and description, or middle item
    final representativeItem =
        items.length > 3 ? items[items.length ~/ 2] : items.first;

    return ForecastDayModel(
      date: DateTime(date.year, date.month, date.day),
      dayTemp: avgTemp,
      minTemp: min,
      maxTemp: max,
      description: representativeItem.description,
      icon: representativeItem.icon,
      hourlyItems: items,
    );
  }

  @override
  List<Object?> get props =>
      [date, dayTemp, minTemp, maxTemp, description, icon, hourlyItems];
}
