import '../../data/models/favorites.dart';
import '../repository/favorites_repository.dart';

class GetAllFavoritesUseCase {
  final FavoritesRepository favoritesRepository;

  GetAllFavoritesUseCase(this.favoritesRepository);

  Future<List<Favorites>> call() {
    return favoritesRepository.getAllFavorites();
  }
}