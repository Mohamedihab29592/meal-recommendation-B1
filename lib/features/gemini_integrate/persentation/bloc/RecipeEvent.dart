abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {
  final String query;
  FetchRecipesEvent(this.query);
}