import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../domain/repositories/favorites_repository_interface.dart';

final favoritesLocalDataSourceProvider =
    Provider<IFavoritesLocalDataSource>((ref) {
  return FavoritesLocalDataSource();
});

final favoritesRepositoryProvider = Provider<IFavoritesRepository>((ref) {
  final dataSource = ref.watch(favoritesLocalDataSourceProvider);
  return FavoritesRepository(localDataSource: dataSource);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final IFavoritesRepository repository;

  FavoritesNotifier({required this.repository})
      : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final cities = await repository.getFavoriteCities();
      state = AsyncValue.data(cities);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(String cityName) async {
    final currentList = state.value ?? [];
    final exists = currentList
        .any((c) => c.toLowerCase() == cityName.trim().toLowerCase());

    if (exists) {
      await repository.removeFavorite(cityName);
      final updated = currentList
          .where((c) => c.toLowerCase() != cityName.trim().toLowerCase())
          .toList();
      state = AsyncValue.data(updated);
    } else {
      await repository.addFavorite(cityName);
      final updated = [...currentList, cityName.trim()];
      state = AsyncValue.data(updated);
    }
  }

  bool isFavorite(String cityName) {
    final currentList = state.value ?? [];
    return currentList
        .any((c) => c.toLowerCase() == cityName.trim().toLowerCase());
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository: repository);
});
