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
  final List<String> fakeDb = [];

  setUp(() {
    mockWeather = MockWeatherRepo();
    mockFavorites = MockFavoritesRepo();
    fakeDb.clear();

    when(() => mockFavorites.getFavoriteCities())
        .thenAnswer((_) async => fakeDb);
    when(() => mockFavorites.addFavorite(any())).thenAnswer((inv) async {
      fakeDb.add(inv.positionalArguments.first as String);
    });
    when(() => mockFavorites.removeFavorite(any())).thenAnswer((inv) async {
      fakeDb.remove(inv.positionalArguments.first as String);
    });

    when(() => mockWeather.getCurrentWeather(any(), units: any(named: 'units')))
        .thenAnswer((inv) async {
      final city = inv.positionalArguments.first as String;
      return WeatherModel(
        cityName: city,
        country: 'FR',
        temperature: 22.0,
        feelsLike: 21.0,
        tempMin: 19.0,
        tempMax: 24.0,
        humidity: 50,
        pressure: 1013,
        windSpeed: 4.0,
        description: 'Clear sky',
        icon: '01d',
        dateTime: DateTime.now(),
      );
    });
  });

  testWidgets(
      'Flow: search city -> view detail -> add to favorites -> find in favorites screen',
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

    // 1. Enter city "Bordeaux" in search bar
    final searchField = find.byKey(const Key('search_text_field'));
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Bordeaux');
    await tester.tap(find.byKey(const Key('search_button')));
    await tester.pumpAndSettle();

    // 2. Tap on the weather card to open details
    final weatherCard = find.text('Bordeaux');
    expect(weatherCard, findsOneWidget);
    await tester.tap(weatherCard);
    await tester.pumpAndSettle();

    // 3. Verify on CityDetailScreen
    expect(find.byKey(const Key('favorite_toggle_button')), findsOneWidget);

    // 4. Tap favorite button
    await tester.tap(find.byKey(const Key('favorite_toggle_button')));
    await tester.pumpAndSettle();

    // 5. Navigate back to Home
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
    } else {
      final popButton = find.byType(BackButton);
      await tester.tap(popButton);
    }
    await tester.pumpAndSettle();

    // 6. Open Favorites Screen from Home AppBar
    final favNavButton = find.byIcon(Icons.favorite_rounded);
    await tester.tap(favNavButton);
    await tester.pumpAndSettle();

    // 7. Verify "Bordeaux" is present in Favorites screen
    expect(find.text('Bordeaux'), findsOneWidget);
  });
}
