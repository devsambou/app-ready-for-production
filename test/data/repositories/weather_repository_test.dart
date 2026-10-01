import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';

class MockWeatherRemoteDataSource extends Mock
    implements IWeatherRemoteDataSource {}

void main() {
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late WeatherRepository repository;

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepository(remoteDataSource: mockRemoteDataSource);
  });

  const tCityName = 'Paris';
  final tJsonWeather = {
    'name': 'Paris',
    'sys': {'country': 'FR'},
    'main': {
      'temp': 21.5,
      'feels_like': 20.8,
      'temp_min': 19.0,
      'temp_max': 23.0,
      'humidity': 55,
      'pressure': 1013,
    },
    'wind': {'speed': 4.2},
    'weather': [
      {'description': 'Clear sky', 'icon': '01d'}
    ],
    'dt': 1696160000,
  };

  group('WeatherRepository - getCurrentWeather', () {
    test('returns WeatherModel when remote call succeeds', () async {
      when(() => mockRemoteDataSource.fetchCurrentWeather(tCityName,
          units: 'metric')).thenAnswer((_) async => tJsonWeather);

      final result =
          await repository.getCurrentWeather(tCityName, units: 'metric');

      expect(result.cityName, equals('Paris'));
      expect(result.country, equals('FR'));
      expect(result.temperature, equals(21.5));
      expect(result.description, equals('Clear sky'));
      verify(() => mockRemoteDataSource.fetchCurrentWeather(tCityName,
          units: 'metric')).called(1);
    });

    test('throws exception when remote data source reports CITY_NOT_FOUND',
        () async {
      when(() => mockRemoteDataSource.fetchCurrentWeather('UnknownCity',
          units: 'metric')).thenThrow(Exception('CITY_NOT_FOUND'));

      expect(
        () => repository.getCurrentWeather('UnknownCity', units: 'metric'),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception when remote data source reports NETWORK_ERROR',
        () async {
      when(() => mockRemoteDataSource.fetchCurrentWeather(tCityName,
          units: 'metric')).thenThrow(Exception('NETWORK_ERROR'));

      expect(
        () => repository.getCurrentWeather(tCityName, units: 'metric'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
