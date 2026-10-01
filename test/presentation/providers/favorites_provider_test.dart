import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/repositories/favorites_repository_interface.dart';
import 'package:weather_app/presentation/providers/favorites_provider.dart';

class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

void main() {
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
  });

  test('FavoritesNotifier loads initial list from repository', () async {
    when(() => mockRepository.getFavoriteCities())
        .thenAnswer((_) async => ['Paris', 'Lyon']);

    final notifier = FavoritesNotifier(repository: mockRepository);
    await notifier.loadFavorites();

    expect(notifier.state.value, equals(['Paris', 'Lyon']));
  });

  test('toggleFavorite adds city if absent and removes if present', () async {
    when(() => mockRepository.getFavoriteCities())
        .thenAnswer((_) async => ['Paris']);
    when(() => mockRepository.addFavorite(any())).thenAnswer((_) async {});
    when(() => mockRepository.removeFavorite(any())).thenAnswer((_) async {});

    final notifier = FavoritesNotifier(repository: mockRepository);
    await notifier.loadFavorites();

    // Add Marseille
    await notifier.toggleFavorite('Marseille');
    expect(notifier.state.value, contains('Marseille'));
    verify(() => mockRepository.addFavorite('Marseille')).called(1);

    // Remove Paris
    await notifier.toggleFavorite('Paris');
    expect(notifier.state.value, isNot(contains('Paris')));
    verify(() => mockRepository.removeFavorite('Paris')).called(1);
  });
}
