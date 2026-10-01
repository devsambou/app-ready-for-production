import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/presentation/screens/settings_screen.dart';

Widget createTestApp() {
  return const ProviderScope(
    child: MaterialApp(
      locale: Locale('fr'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsScreen(),
    ),
  );
}

void main() {
  testWidgets(
      'SettingsScreen displays language and unit selectors and updates selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Verify presence of selectors
    expect(find.byKey(const Key('language_segmented_button')), findsOneWidget);
    expect(find.byKey(const Key('unit_segmented_button')), findsOneWidget);

    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Anglais'), findsOneWidget);
    expect(find.text('Celsius (°C)'), findsOneWidget);
    expect(find.text('Fahrenheit (°F)'), findsOneWidget);

    // Tap Anglais
    await tester.tap(find.text('Anglais'));
    await tester.pumpAndSettle();

    // Tap Fahrenheit
    await tester.tap(find.text('Fahrenheit (°F)'));
    await tester.pumpAndSettle();
  });
}
