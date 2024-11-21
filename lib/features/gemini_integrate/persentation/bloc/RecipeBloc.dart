import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/ServerException.dart';
import '../../data/Recipe.dart';
import '../../data/RecipeRepository.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final List<Recipe> _fetchedRecipes = [];
  final List<Recipe> _savedRecipes = [];

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SaveRecipesEvent>(_onSaveRecipes);
    on<LoadSavedRecipesEvent>(_onLoadSavedRecipes);
    on<CombineRecipesEvent>(_onCombineRecipes);
    on<CleanupRecipesEvent>(_onCleanupRecipes);
  }

  Future<void> _onFetchRecipes(
      FetchRecipesEvent event, Emitter<RecipeState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(RecipeError("Please enter a valid recipe search query.", false));
      return;
    }

    emit(RecipeLoading());

    try {
      // Clear previous fetched recipes before new fetch
      _fetchedRecipes.clear();

      final newRecipes = await recipeRepository.fetchRecipes(event.query);

      // Enhanced logging
      _logFetchedRecipes(newRecipes, event.query);

      if (newRecipes.isEmpty) {
        emit(RecipeError(
            "No recipes found for '${event.query}'. Try a different search term.",
            true));
        return;
      }

      // Validate and add recipes
      final validRecipes = _validateRecipes(newRecipes);
      _fetchedRecipes.addAll(validRecipes);

      // Debug print to verify fetched recipes
      print('Fetched Recipes After Validation: ${_fetchedRecipes.length}');

      // Emit loaded state with fetched recipes
      emit(RecipeLoaded(_fetchedRecipes));
    } on ServerException catch (e) {
      emit(RecipeError(e.message, true));
    } catch (e) {
      emit(RecipeError("An unexpected error occurred: $e", true));
    }
  }

  Future<void> _onSaveRecipes(
      SaveRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      print('Attempting to save recipes');
      print('Fetched Recipes Count Before Save: ${_fetchedRecipes.length}');

      List<Recipe> recipesToSave = _fetchedRecipes;

      // If fetched recipes are empty, check the current state
      if (recipesToSave.isEmpty) {
        final currentState = state;
        if (currentState is RecipeLoaded) {
          recipesToSave = currentState.recipes;
        }
      }

      // Validate recipes
      final validRecipes = _validateRecipes(recipesToSave);

      print('Valid Recipes Count: ${validRecipes.length}');

      if (validRecipes.isEmpty) {
        emit(RecipeError("No valid recipes to save", false));
        return;
      }

      // Save recipes
      await recipeRepository.saveRecipes(validRecipes);

      // Update saved recipes
      _savedRecipes.addAll(validRecipes);

      // Optionally, remove saved recipes from fetched recipes
      _fetchedRecipes.removeWhere((fetchedRecipe) =>
          validRecipes.any((savedRecipe) =>
          savedRecipe.id == fetchedRecipe.id ||
              savedRecipe.name == fetchedRecipe.name
          )
      );
      _debugRecipeState();
      // Emit updated state
      emit(SavedRecipesLoaded(_savedRecipes));

      // Trigger combine to update overall view
      add(CombineRecipesEvent());

    } catch (e) {
      print('Error saving recipes: $e');
      emit(RecipeError("Failed to save recipes: $e", true));
    }
  }

  Future<void> _onLoadSavedRecipes(
      LoadSavedRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      emit(RecipeLoading());

      final savedRecipes = await recipeRepository.fetchSavedRecipes();

      _savedRecipes.clear();
      _savedRecipes.addAll(savedRecipes);

      emit(SavedRecipesLoaded(savedRecipes));
    } catch (e) {
      emit(RecipeError("Failed to load saved recipes: $e", true));
    }
  }

  Future<void> _onCombineRecipes(
      CombineRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      // Create a combined list of saved and fetched recipes
      final combinedRecipes = [
        ..._savedRecipes,
        ..._fetchedRecipes
      ];

      // Remove duplicates
      final uniqueRecipes = _removeDuplicateRecipes(combinedRecipes);

      // Log combination details
      print('Combining Recipes:');
      print('Saved Recipes: ${_savedRecipes.length}');
      print('Fetched Recipes: ${_fetchedRecipes.length}');
      print('Combined Unique Recipes: ${uniqueRecipes.length}');

      // Emit the combined recipes
      emit(RecipeLoaded(uniqueRecipes));
    } catch (e) {
      print('Error combining recipes: $e');
      emit(RecipeError('Failed to combine recipes: $e', true));
    }
  }


  Future<void> _onCleanupRecipes(
      CleanupRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      // Emit loading state
      emit(RecipeLoading());

      // Perform cleanup with repository method
      await recipeRepository.performCompleteCleanup(
        deleteGenerated: event.deleteGenerated,
        archiveOld: event.archiveOld,
        daysOld: event.daysOld,
      );

      // Fetch updated saved recipes
      final updatedRecipes = await recipeRepository.fetchSavedRecipes();

      // Update local saved recipes list
      _savedRecipes.clear();
      _savedRecipes.addAll(updatedRecipes);

      // Log cleanup details
      print('Recipes Cleanup:');
      print('Delete Generated: ${event.deleteGenerated}');
      print('Archive Old: ${event.archiveOld}');
      print('Days Old: ${event.daysOld}');
      print('Updated Saved Recipes: ${updatedRecipes.length}');

      // Emit updated saved recipes state
      emit(SavedRecipesLoaded(updatedRecipes));
    } catch (e) {
      print('Cleanup Recipes Error: $e');
      emit(RecipeError('Failed to cleanup recipes: $e', true));
    }
  }

  List<Recipe> _removeDuplicateRecipes(List<Recipe> recipes) {
    // Remove duplicates based on a unique identifier (e.g., name or custom ID)
    final uniqueRecipes = <Recipe>[];
    final seenRecipes = <String>{};

    for (final recipe in recipes) {
      // Use a unique identifier - adjust based on your Recipe model
      final identifier = recipe.id ?? recipe.name;

      if (identifier != null && !seenRecipes.contains(identifier)) {
        uniqueRecipes.add(recipe);
        seenRecipes.add(identifier);
      }
    }

    return uniqueRecipes;
  }

  void clearFetchedRecipes() {
    _fetchedRecipes.clear();
    add(CombineRecipesEvent());
  }

  void clearSavedRecipes() {
    _savedRecipes.clear();
    add(CombineRecipesEvent());
  }
  List<Recipe> _validateRecipes(List<Recipe> recipes) {
    return recipes.where((recipe) {
      bool isValid = recipe.name.trim().isNotEmpty &&
          recipe.ingredients.isNotEmpty;

      if (!isValid) {
        print('Invalid Recipe Detected:');
        print('  Name: ${recipe.name}');
        print('  Ingredients: ${recipe.ingredients?.length ?? 0}');
      }

      return isValid;
    }).toList();
  }

  void _debugRecipeState() {
    print('Current Recipe State:');
    print('Fetched Recipes: ${_fetchedRecipes.length}');
    print('Saved Recipes: ${_savedRecipes.length}');

    if (_fetchedRecipes.isNotEmpty) {
      _fetchedRecipes.forEach((recipe) {
        print('Fetched Recipe: ${recipe.name}');
      });
    }

    if (_savedRecipes.isNotEmpty) {
      _savedRecipes.forEach((recipe) {
        print('Saved Recipe: ${recipe.name}');
      });
    }
  }

  void _logFetchedRecipes(List<Recipe> recipes, String query) {
    print('Fetched Recipes for Query: $query');
    print('Total Recipes Found: ${recipes.length}');

    if (recipes.isEmpty) {
      print('No recipes were fetched');
      return;
    }

    recipes.asMap().forEach((index, recipe) {
      print('Recipe #${index + 1}:');
      print('  Name: ${recipe.name ?? 'N/A'}');
      print('  Ingredients: ${recipe.ingredients?.length ?? 0}');
    });

  }

  List<Recipe> get fetchedRecipes => List.unmodifiable(_fetchedRecipes);
  List<Recipe> get savedRecipes => List.unmodifiable(_savedRecipes);
}

