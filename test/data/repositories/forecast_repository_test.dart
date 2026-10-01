import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/repositories/forecast_repository.dart';

class MockWeatherRemoteDataSource extends Mock
    implements IWeatherRemoteDataSource {}

void main() {
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late ForecastRepository repository;

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    repository = ForecastRepository(remoteDataSource: mockRemoteDataSource);
  });

  const tCityName = 'Paris';

  final tRawForecastJson = {
    'list': [
      // Day 1: Oct 1
      {
        'dt': 1696150800, // 2023-10-01 09:00:00
        'main': {
          'temp': 18.0,
          'temp_min': 17.0,
          'temp_max': 19.0,
          'humidity': 60
        },
        'wind': {'speed': 3.0},
        'weather': [
          {'description': 'Few clouds', 'icon': '02d'}
        ],
      },
      {
        'dt': 1696161600, // 2023-10-01 12:00:00
        'main': {
          'temp': 22.0,
          'temp_min': 20.0,
          'temp_max': 24.0,
          'humidity': 50
        },
        'wind': {'speed': 4.0},
        'weather': [
          {'description': 'Sunny', 'icon': '01d'}
        ],
      },
      // Day 2: Oct 2
      {
        'dt': 1696237200, // 2023-10-02 09:00:00
        'main': {
          'temp': 16.0,
          'temp_min': 15.0,
          'temp_max': 17.0,
          'humidity': 70
        },
        'wind': {'speed': 5.0},
        'weather': [
          {'description': 'Rain', 'icon': '10d'}
        ],
      },
    ],
  };

  group('ForecastRepository - 3h to Day Aggregation', () {
    test('getRawHourlyForecast returns parsed list of 3-hour items', () async {
      when(() => mockRemoteDataSource.fetchForecast(tCityName, units: 'metric'))
          .thenAnswer((_) async => tRawForecastJson);

      final items =
          await repository.getRawHourlyForecast(tCityName, units: 'metric');

      expect(items.length, equals(3));
      expect(items.first.temperature, equals(18.0));
      expect(items.first.description, equals('Few clouds'));
    });

    test(
        'getFiveDayForecast aggregates multiple 3h items into unique daily forecast',
        () async {
      when(() => mockRemoteDataSource.fetchForecast(tCityName, units: 'metric'))
          .thenAnswer((_) async => tRawForecastJson);

      final daily =
          await repository.getFiveDayForecast(tCityName, units: 'metric');

      expect(daily.length, equals(2));
      final day1 = daily.first;
      // Day 1 has 18.0 and 22.0 -> avg = 20.0, min = 17.0, max = 24.0
      expect(day1.minTemp, equals(17.0));
      expect(day1.maxTemp, equals(24.0));
      expect(day1.dayTemp, equals(20.0));
      expect(day1.hourlyItems.length, equals(2));
    });

    test('getFiveDayForecast returns empty list when API returns empty list',
        () async {
      when(() => mockRemoteDataSource.fetchForecast(tCityName, units: 'metric'))
          .thenAnswer((_) async => {'list': []});

      final daily =
          await repository.getFiveDayForecast(tCityName, units: 'metric');

      expect(daily, isEmpty);
    });
  });
}
