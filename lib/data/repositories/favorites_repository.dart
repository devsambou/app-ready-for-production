import '../../domain/repositories/favorites_repository_interface.dart';
import '../datasources/favorites_local_data_source.dart';

/// Concrete implementation of [IFavoritesRepository] delegating to Hive storage.
class FavoritesRepository implements IFavoritesRepository {
  final IFavoritesLocalDataSource localDataSource;

  FavoritesRepository({required this.localDataSource});

  @override
  Future<List<String>> getFavoriteCities() {
    return localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(String cityName) {
    return localDataSource.addFavorite(cityName);
  }

  @override
  Future<void> removeFavorite(String cityName) {
    return localDataSource.removeFavorite(cityName);
  }

  @override
  Future<bool> isFavorite(String cityName) {
    return localDataSource.isFavorite(cityName);
  }
}
