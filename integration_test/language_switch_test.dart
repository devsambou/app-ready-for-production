import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/models/weather_model.dart';
import 'package:weather_app/domain/repositories/favorites_repository_interface.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/presentation/providers/favorites_provider.dart';
import 'package:weather_app/presentation/providers/weather_providers.dart';

class MockWeatherRepo extends Mock implements IWeatherRepository {}

class MockFavoritesRepo extends Mock implements IFavoritesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockWeatherRepo mockWeather;
  late MockFavoritesRepo mockFavorites;

  setUp(() {
    mockWeather = MockWeatherRepo();
    mockFavorites = MockFavoritesRepo();

    when(() => mockFavorites.getFavoriteCities()).thenAnswer((_) async => []);
    when(() => mockWeather.getCurrentWeather(any(), units: any(named: 'units')))
        .thenAnswer((inv) async {
      return WeatherModel(
        cityName: 'Paris',
        country: 'FR',
        temperature: 20.0,
        feelsLike: 20.0,
        tempMin: 18.0,
        tempMax: 22.0,
        humidity: 50,
        pressure: 1013,
        windSpeed: 3.0,
        description: 'Ensoleillé',
        icon: '01d',
        dateTime: DateTime.now(),
      );
    });
  });

  testWidgets(
      'Flow: open settings -> switch language -> verify UI is translated in real-time',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockWeather),
          favoritesRepositoryProvider.overrideWithValue(mockFavorites),
        ],
        child: const WeatherApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Open Settings Screen
    final settingsButton = find.byIcon(Icons.settings_rounded);
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();

    // 2. Initial language is French
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);

    // 3. Switch to English
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // 4. Verify texts are now English
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);

    // 5. Switch back to French
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    // 6. Verify back to French
    expect(find.text('Paramètres'), findsOneWidget);
  });
}
