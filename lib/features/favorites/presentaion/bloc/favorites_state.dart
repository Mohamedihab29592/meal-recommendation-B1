
import 'package:meal_recommendation_b1/features/gemini_integrate/data/Recipe.dart';

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
  final List<Recipe> favorites;
  GetAllFavoritesDone(this.favorites);
}
class GetAllFavoritesError extends FavoritesState {
  final String message;
  GetAllFavoritesError(this.message);
}