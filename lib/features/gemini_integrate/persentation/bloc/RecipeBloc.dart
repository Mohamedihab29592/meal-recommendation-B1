import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/Recipe.dart';
import '../../data/RecipeRepository.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final List<Recipe> _recipeList = []; // Maintain a list of all recipes

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    // Register event handlers
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SaveRecipesEvent>(_onSaveRecipes);
    on<LoadSavedRecipesEvent>(_onLoadSavedRecipes);
    on<ClearGeneratedRecipesEvent>(_onClearGeneratedRecipes);
  }

  Future<void> _onFetchRecipes(
      FetchRecipesEvent event,
      Emitter<RecipeState> emit
      ) async {
    emit(RecipeLoading());

    try {
      final newRecipes = await recipeRepository.fetchRecipes(event.query);

      // Clear previous recipes if you want only new results
      _recipeList.clear();
      _recipeList.addAll(newRecipes);

      emit(RecipeLoaded(List<Recipe>.from(_recipeList)));
    } catch (e) {
      emit(RecipeError("Failed to load recipes: ${e.toString()}"));
    }
  }

  Future<void> _onSaveRecipes(
      SaveRecipesEvent event,
      Emitter<RecipeState> emit
      ) async {
    if (_recipeList.isEmpty) {
      emit(RecipeError("No recipes to save"));
      return;
    }

    try {
      await recipeRepository.saveRecipes(_recipeList);
      emit(RecipesSaved());
    } catch (e) {
      emit(RecipeError("Failed to save recipes: ${e.toString()}"));
    }
  }

  Future<void> _onLoadSavedRecipes(
      LoadSavedRecipesEvent event,
      Emitter<RecipeState> emit
      ) async {
    emit(RecipeLoading());

    try {
      final savedRecipes = await recipeRepository.fetchSavedRecipes();

      if (savedRecipes.isEmpty) {
        emit(RecipeError("No saved recipes found"));
      } else {
        emit(SavedRecipesLoaded(savedRecipes));
      }
    } catch (e) {
      emit(RecipeError("Failed to load saved recipes: ${e.toString()}"));
    }
  }

  Future<void> _onClearGeneratedRecipes(
      ClearGeneratedRecipesEvent event,
      Emitter<RecipeState> emit
      ) async {
    emit(RecipeLoading());

    try {
      // Clear local list
      _recipeList.clear();

      // Perform cleanup in repository
      await recipeRepository.performCompleteCleanup();


      final updatedRecipes = await recipeRepository.fetchSavedRecipes();

      emit(RecipeLoaded(updatedRecipes));
    } catch (e) {
      emit(RecipeError('Failed to clear recipes: ${e.toString()}'));
    }
  }

  // Optional: Method to add a single recipe to the list
  void addRecipe(Recipe recipe) {
    _recipeList.add(recipe);
    add(SaveRecipesEvent()); // Automatically save when adding
  }

  // Optional: Method to remove a specific recipe
  void removeRecipe(Recipe recipe) {
    _recipeList.remove(recipe);
    add(SaveRecipesEvent()); // Automatically save after removal
  }
}