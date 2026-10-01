import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

abstract class IFavoritesLocalDataSource {
  Future<List<String>> getFavorites();
  Future<void> addFavorite(String cityName);
  Future<void> removeFavorite(String cityName);
  Future<bool> isFavorite(String cityName);
}

class FavoritesLocalDataSource implements IFavoritesLocalDataSource {
  final Box<dynamic>? customBox;

  FavoritesLocalDataSource({this.customBox});

  Box<dynamic> _getBox() {
    return customBox ?? Hive.box<dynamic>(AppConstants.hiveFavoritesBox);
  }

  @override
  Future<List<String>> getFavorites() async {
    final box = _getBox();
    final list = box.get('cities', defaultValue: <String>[]);
    return List<String>.from(list as List);
  }

  @override
  Future<void> addFavorite(String cityName) async {
    final box = _getBox();
    final current = await getFavorites();
    final normalized = cityName.trim();
    if (!current.any((c) => c.toLowerCase() == normalized.toLowerCase())) {
      current.add(normalized);
      await box.put('cities', current);
    }
  }

  @override
  Future<void> removeFavorite(String cityName) async {
    final box = _getBox();
    final current = await getFavorites();
    current
        .removeWhere((c) => c.toLowerCase() == cityName.trim().toLowerCase());
    await box.put('cities', current);
  }

  @override
  Future<bool> isFavorite(String cityName) async {
    final current = await getFavorites();
    return current.any((c) => c.toLowerCase() == cityName.trim().toLowerCase());
  }
}
