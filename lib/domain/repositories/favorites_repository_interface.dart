/// Contract for local storage of favorite cities.
/// Only city names/primitive IDs are stored, never complex un-serialized models.
abstract class IFavoritesRepository {
  Future<List<String>> getFavoriteCities();
  Future<void> addFavorite(String cityName);
  Future<void> removeFavorite(String cityName);
  Future<bool> isFavorite(String cityName);
}
