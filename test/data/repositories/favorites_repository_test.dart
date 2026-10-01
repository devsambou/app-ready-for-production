import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/datasources/favorites_local_data_source.dart';
import 'package:weather_app/data/repositories/favorites_repository.dart';

class MockFavoritesLocalDataSource extends Mock
    implements IFavoritesLocalDataSource {}

void main() {
  late MockFavoritesLocalDataSource mockDataSource;
  late FavoritesRepository repository;

  setUp(() {
    mockDataSource = MockFavoritesLocalDataSource();
    repository = FavoritesRepository(localDataSource: mockDataSource);
  });

  group('FavoritesRepository', () {
    test('getFavoriteCities delegates to localDataSource', () async {
      when(() => mockDataSource.getFavorites())
          .thenAnswer((_) async => ['Paris', 'Lyon']);

      final result = await repository.getFavoriteCities();

      expect(result, equals(['Paris', 'Lyon']));
      verify(() => mockDataSource.getFavorites()).called(1);
    });

    test('addFavorite delegates to localDataSource', () async {
      when(() => mockDataSource.addFavorite('Marseille'))
          .thenAnswer((_) async {});

      await repository.addFavorite('Marseille');

      verify(() => mockDataSource.addFavorite('Marseille')).called(1);
    });

    test('removeFavorite delegates to localDataSource', () async {
      when(() => mockDataSource.removeFavorite('Paris'))
          .thenAnswer((_) async {});

      await repository.removeFavorite('Paris');

      verify(() => mockDataSource.removeFavorite('Paris')).called(1);
    });

    test('isFavorite checks presence in localDataSource', () async {
      when(() => mockDataSource.isFavorite('Paris'))
          .thenAnswer((_) async => true);
      when(() => mockDataSource.isFavorite('Tokyo'))
          .thenAnswer((_) async => false);

      expect(await repository.isFavorite('Paris'), isTrue);
      expect(await repository.isFavorite('Tokyo'), isFalse);
    });
  });
}
