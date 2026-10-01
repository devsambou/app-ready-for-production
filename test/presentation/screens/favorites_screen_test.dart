import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/repositories/favorites_repository_interface.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/presentation/providers/favorites_provider.dart';
import 'package:weather_app/presentation/screens/favorites_screen.dart';

class MockFavoritesRepo extends Mock implements IFavoritesRepository {}

Widget createTestApp(IFavoritesRepository repository) {
  return ProviderScope(
    overrides: [
      favoritesRepositoryProvider.overrideWithValue(repository),
    ],
    child: const MaterialApp(
      locale: Locale('fr'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: FavoritesScreen(),
    ),
  );
}

void main() {
  late MockFavoritesRepo mockRepo;

  setUp(() {
    mockRepo = MockFavoritesRepo();
  });

  testWidgets('FavoritesScreen displays empty state when no favorites exist',
      (WidgetTester tester) async {
    when(() => mockRepo.getFavoriteCities()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestApp(mockRepo));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(
        find.text(
            'Aucune ville favorite pour le moment. Ajoutez-en depuis le détail !'),
        findsOneWidget);
  });

  testWidgets('FavoritesScreen displays list of saved cities',
      (WidgetTester tester) async {
    when(() => mockRepo.getFavoriteCities())
        .thenAnswer((_) async => ['Paris', 'Marseille']);

    await tester.pumpWidget(createTestApp(mockRepo));
    await tester.pumpAndSettle();

    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Marseille'), findsOneWidget);
  });
}
