import '../../data/models/favorites.dart';

abstract class FavoritesRepository {
  Future<void> saveFavorite(Favorites favorite);
  Future<void> deleteFavorite(String id);
  Future<List<Favorites>> getAllFavorites();
}