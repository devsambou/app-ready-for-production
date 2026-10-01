import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/models/forecast_day_model.dart';
import 'package:weather_app/domain/models/weather_model.dart';
import 'package:weather_app/domain/repositories/forecast_repository_interface.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';
import 'package:weather_app/presentation/providers/weather_providers.dart';

class MockWeatherRepository extends Mock implements IWeatherRepository {}

class MockForecastRepository extends Mock implements IForecastRepository {}

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late MockForecastRepository mockForecastRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockForecastRepository = MockForecastRepository();
  });

  final tWeather = WeatherModel(
    cityName: 'Paris',
    country: 'FR',
    temperature: 20.0,
    feelsLike: 19.5,
    tempMin: 18.0,
    tempMax: 22.0,
    humidity: 50,
    pressure: 1015,
    windSpeed: 3.5,
    description: 'Clear',
    icon: '01d',
    dateTime: DateTime(2023, 10, 1),
  );

  test('searchQueryProvider defaults to Paris and updates on demand', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(searchQueryProvider), equals('Paris'));

    container.read(searchQueryProvider.notifier).state = 'Tokyo';
    expect(container.read(searchQueryProvider), equals('Tokyo'));
  });

  test('currentWeatherProvider fetches weather from weatherRepositoryProvider',
      () async {
    when(() => mockWeatherRepository.getCurrentWeather('Paris',
        units: any(named: 'units'))).thenAnswer((_) async => tWeather);

    final container = ProviderContainer(
      overrides: [
        weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(currentWeatherProvider('Paris').future);

    expect(result, equals(tWeather));
    verify(() => mockWeatherRepository.getCurrentWeather('Paris',
        units: any(named: 'units'))).called(1);
  });

  test(
      'forecastProvider fetches 5-day forecast from forecastRepositoryProvider',
      () async {
    final tDaily = [
      ForecastDayModel(
        date: DateTime(2023, 10, 1),
        dayTemp: 20.0,
        minTemp: 18.0,
        maxTemp: 22.0,
        description: 'Sunny',
        icon: '01d',
        hourlyItems: const [],
      ),
    ];

    when(() => mockForecastRepository.getFiveDayForecast('Paris',
        units: any(named: 'units'))).thenAnswer((_) async => tDaily);

    final container = ProviderContainer(
      overrides: [
        forecastRepositoryProvider.overrideWithValue(mockForecastRepository),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(forecastProvider('Paris').future);

    expect(result, equals(tDaily));
    verify(() => mockForecastRepository.getFiveDayForecast('Paris',
        units: any(named: 'units'))).called(1);
  });
}
