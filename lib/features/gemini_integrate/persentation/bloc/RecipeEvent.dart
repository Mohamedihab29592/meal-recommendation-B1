
abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {
  final String query;

  FetchRecipesEvent(this.query);
}

class SaveRecipesEvent extends RecipeEvent {}

class LoadSavedRecipesEvent extends RecipeEvent {}

class CleanupRecipesEvent extends RecipeEvent {
  final bool deleteGenerated;
  final bool archiveOld;
  final int daysOld;

  CleanupRecipesEvent({
    this.deleteGenerated = false,
    this.archiveOld = false,
    this.daysOld = 30,
  });
}

class CombineRecipesEvent extends RecipeEvent {}
