import '../repository/favorites_repository.dart';

class DeleteFavoriteUseCase {
  final FavoritesRepository favoritesRepository;

  DeleteFavoriteUseCase(this.favoritesRepository);

  Future<void> call(String id) {
    return favoritesRepository.deleteFavorite(id);
  }
}