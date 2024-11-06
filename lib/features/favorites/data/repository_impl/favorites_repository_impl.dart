
import 'package:hive/hive.dart';

import '../../domain/repository/favorites_repository.dart';
import '../models/favorites.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box<Favorites> favoriteBox;

  FavoritesRepositoryImpl(this.favoriteBox);

  @override
  Future<void> saveFavorite(Favorites favorite) async {
    await favoriteBox.put(favorite.id, favorite);
  }

  @override
  Future<void> deleteFavorite(String id) async {
    await favoriteBox.delete(id);
  }

  @override
  Future<List<Favorites>> getAllFavorites() async {
    return favoriteBox.values.toList();
  }
}