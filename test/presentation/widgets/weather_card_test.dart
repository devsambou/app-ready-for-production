import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/models/weather_model.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/presentation/widgets/weather_card.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  final tWeather = WeatherModel(
    cityName: 'Nice',
    country: 'FR',
    temperature: 25.4,
    feelsLike: 26.0,
    tempMin: 22.0,
    tempMax: 28.0,
    humidity: 45,
    pressure: 1016,
    windSpeed: 3.2,
    description: 'Ensoleillé',
    icon: '01d',
    dateTime: DateTime(2023, 10, 1),
  );

  testWidgets(
      'WeatherCard displays city, temperature, description and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      createTestApp(
        WeatherCard(
          weather: tWeather,
          unitSymbol: '°C',
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );
    await tester.pump();

    // Check display values
    expect(find.text('Nice'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('Ensoleillé'), findsOneWidget);

    // Tap card
    await tester.tap(find.byType(WeatherCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
