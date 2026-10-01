import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/models/forecast_day_model.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/presentation/widgets/forecast_item_card.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
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
  final tDay = ForecastDayModel(
    date: DateTime(2025, 6, 15),
    dayTemp: 22.0,
    minTemp: 18.0,
    maxTemp: 26.0,
    description: 'Nuageux',
    icon: '03d',
    hourlyItems: const [],
  );

  testWidgets('ForecastItemCard displays description and min/max temperatures',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestApp(
        ForecastItemCard(
          forecastDay: tDay,
          unitSymbol: '°C',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Nuageux'), findsOneWidget);
    expect(find.text('26°C'), findsOneWidget);
    expect(find.text('18°C'), findsOneWidget);
  });
}
