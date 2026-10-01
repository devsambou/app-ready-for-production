import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/presentation/widgets/custom_search_bar.dart';

Widget createWidgetUnderTest(Widget child) {
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
  testWidgets(
      'CustomSearchBar renders initial value and triggers onSearch when submitted',
      (WidgetTester tester) async {
    String submittedQuery = '';

    await tester.pumpWidget(
      createWidgetUnderTest(
        CustomSearchBar(
          initialValue: 'Lyon',
          onSearch: (query) {
            submittedQuery = query;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial text
    expect(find.text('Lyon'), findsOneWidget);

    // Enter new text
    await tester.enterText(
        find.byKey(const Key('search_text_field')), 'Bordeaux');
    await tester.tap(find.byKey(const Key('search_button')));
    await tester.pumpAndSettle();

    expect(submittedQuery, equals('Bordeaux'));
  });
}
