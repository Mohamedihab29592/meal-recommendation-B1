
import '../../data/models/favorites.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class SaveFavoriteDone extends FavoritesState {}
class SaveFavoriteError extends FavoritesState {
  final String message;
  SaveFavoriteError(this.message);
}

class DeleteFavoriteDone extends FavoritesState {}
class DeleteFavoriteError extends FavoritesState {
  final String message;
  DeleteFavoriteError(this.message);
}

class GetAllFavoritesDone extends FavoritesState {
  final List<Favorites> favorites;
  GetAllFavoritesDone(this.favorites);
}
class GetAllFavoritesError extends FavoritesState {
  final String message;
  GetAllFavoritesError(this.message);
}