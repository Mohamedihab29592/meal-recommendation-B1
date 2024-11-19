abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {
  final String query;

  FetchRecipesEvent(this.query);
}

class SaveRecipesEvent extends RecipeEvent {}

class LoadSavedRecipesEvent extends RecipeEvent {}

class ClearGeneratedRecipesEvent extends RecipeEvent {}
