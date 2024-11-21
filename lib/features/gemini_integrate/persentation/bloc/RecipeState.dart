import '../../data/Recipe.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoaded(this.recipes);
}

class RecipesSaved extends RecipeState {}

class SavedRecipesLoaded extends RecipeState {
  final List<Recipe> savedRecipes;
  SavedRecipesLoaded(this.savedRecipes);
}

class RecipeError extends RecipeState {
  final String message;
  final bool canRetry;

  RecipeError(this.message, this.canRetry);
}
class NoSavedRecipes extends RecipeState {}
