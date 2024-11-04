import '../../data/models/favorites.dart';

abstract class FavoritesEvent {}

class SaveFavoriteEvent extends FavoritesEvent{
  final Favorites favorite;
  SaveFavoriteEvent(this.favorite);
}

class DeleteFavoriteEvent extends FavoritesEvent{
  final String id;
  DeleteFavoriteEvent(this.id);
}

class GetAllFavoritesEvent extends FavoritesEvent{}