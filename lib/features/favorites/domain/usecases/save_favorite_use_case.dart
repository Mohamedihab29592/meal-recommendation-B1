import '../../data/models/favorites.dart';
import '../repository/favorites_repository.dart';

class SaveFavoriteUseCase {
  final FavoritesRepository favoritesRepository;

  SaveFavoriteUseCase(this.favoritesRepository);

  Future<void> call(Favorites favorite) {
    return favoritesRepository.saveFavorite(favorite);
  }
}