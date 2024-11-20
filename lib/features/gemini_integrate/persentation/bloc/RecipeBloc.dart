import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/ServerException.dart';
import '../../data/Recipe.dart';
import '../../data/RecipeRepository.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final List<Recipe> _fetchedRecipes = []; // Fetched from Gemini
  final List<Recipe> _savedRecipes = []; // Saved recipes

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SaveRecipesEvent>(_onSaveRecipes);
    on<LoadSavedRecipesEvent>(_onLoadSavedRecipes);
    on<CleanupRecipesEvent>(_onCleanupRecipes);
    on<CombineRecipesEvent>(_onCombineRecipes);
  }

  Future<void> _onFetchRecipes(
      FetchRecipesEvent event, Emitter<RecipeState> emit) async {
    // Validate input query
    if (event.query.trim().isEmpty) {
      emit(RecipeError("Please enter a valid recipe search query.", false));
      return;
    }

    emit(RecipeLoading());

    try {
      final newRecipes = await recipeRepository.fetchRecipes(event.query);

      // Debug logging
      _logRecipeFetchDetails(newRecipes, event.query);

      // Check if no recipes were found
      if (newRecipes.isEmpty) {
        emit(RecipeError(
            "No recipes found for '${event.query}'. Try a different search term.",
            true));
        return;
      }

      _fetchedRecipes.addAll(newRecipes);

      // Combine fetched and saved recipes
      final combinedRecipes = [..._savedRecipes, ..._fetchedRecipes];

      // Ensure unique recipes (if needed)
      final uniqueRecipes = _removeDuplicateRecipes(combinedRecipes);

      // Emit loaded state with recipes
      emit(RecipeLoaded(uniqueRecipes));
    } on ServerException catch (e) {
      // Comprehensive server error handling
      _handleServerException(e, emit);
    } catch (e) {
      // Catch-all for unexpected errors
      _handleUnexpectedError(e, emit);
    }
  }

  void _logRecipeFetchDetails(List<Recipe> recipes, String query) {
    print('Fetched Recipes for Query: $query');
    print('Total Recipes Found: ${recipes.length}');

    recipes.asMap().forEach((index, recipe) {
      print('Recipe #${index + 1}:');
      print('  Name: ${recipe.name}');
      print('  ID: ${recipe.id}');
      // Add more detailed logging as needed
    });
  }

  List<Recipe> _removeDuplicateRecipes(List<Recipe> recipes) {
    return recipes.toSet().toList();
  }

  void _handleServerException(ServerException e, Emitter<RecipeState> emit) {
    switch (e.statusCode) {
      case 503:
        emit(RecipeError(
            "Service is temporarily unavailable. Please try again later.",
            true));
        break;
      case 404:
        emit(RecipeError(
            "No recipes found. Please try a different query.", false));
        break;
      case 401:
        emit(RecipeError("Authentication failed. Please log in again.", false));
        break;
      case 500:
        emit(RecipeError(
            "Internal server error. Our team has been notified.", true));
        break;
      default:
        emit(RecipeError("An error occurred: ${e.message}", true));
    }
  }


  void _handleUnexpectedError(Object e, Emitter<RecipeState> emit) {
    print('Unexpected Error: $e');

    emit(RecipeError("An unexpected error occurred. Please try again.", true));
  }

  Future<void> _onLoadSavedRecipes(
      LoadSavedRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());

    try {
      // Fetch saved recipes
      _savedRecipes.clear();
      final savedRecipes = await recipeRepository.fetchSavedRecipes();
      _savedRecipes.addAll(savedRecipes);

      emit(SavedRecipesLoaded(_savedRecipes));
    } catch (e) {
      emit(RecipeError("Failed to load saved recipes: ${e.toString()}", true));
    }
  }

  Future<void> _onSaveRecipes(
      SaveRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      // Comprehensive logging
      print('Save Recipes Event triggered');
      print('Fetched Recipes Count: ${_fetchedRecipes.length}');

      // Detailed recipe logging
      _fetchedRecipes.forEach((recipe) {
        print('Fetched Recipe Details:');
        print('Name: ${recipe.name}');
        print('ID: ${recipe.id}');
        print('Is Name Null: ${recipe.name == null}');
        print('Is ID Null: ${recipe.id == null}');
      });

      // Check if there are any fetched recipes
      if (_fetchedRecipes.isEmpty) {
        print('No recipes to save');
        emit(RecipeError("No recipes to save", true));
        return;
      }

      final validRecipes = _fetchedRecipes.where((recipe) {
        bool isValid =
            recipe.id != null && recipe.name.isNotEmpty;

        if (!isValid) {
          print('Invalid recipe found: ${recipe.name ?? 'Unnamed recipe'}');
          print('Recipe ID: ${recipe.id}');
        }

        return isValid;
      }).toList();

      print('Valid Recipes Count: ${validRecipes.length}');


      if (validRecipes.isEmpty) {
        print('No valid recipes to save');
        emit(RecipeError("No valid recipes to save", false));
        return;
      }

      // Rest of the method remains the same...
    } catch (e, stackTrace) {
      print("Unexpected error in save recipes: $e");
      print("Stack trace: $stackTrace");

      emit(RecipeError("Unexpected error: ${e.toString()}", true));
    }
  }

  Future<void> _onCleanupRecipes(
      CleanupRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());

    try {
      await recipeRepository.performCompleteCleanup(
        deleteGenerated: event.deleteGenerated,
        archiveOld: event.archiveOld,
        daysOld: event.daysOld,
      );

      final updatedRecipes = await recipeRepository.fetchSavedRecipes();
      _savedRecipes.clear();
      _savedRecipes.addAll(updatedRecipes);

      emit(SavedRecipesLoaded(updatedRecipes));
    } catch (e) {
      emit(RecipeError('Failed to cleanup recipes: ${e.toString()}', true));
    }
  }

  Future<void> _onCombineRecipes(
      CombineRecipesEvent event, Emitter<RecipeState> emit) async {
    final combinedRecipes = [..._savedRecipes, ..._fetchedRecipes];
    emit(RecipeLoaded(combinedRecipes));
  }

  // Utility methods
  void addRecipe(Recipe recipe) {
    _fetchedRecipes.add(recipe);
    add(SaveRecipesEvent());
  }

  void removeRecipe(Recipe recipe) {
    _savedRecipes.remove(recipe);
    add(SaveRecipesEvent());
  }

  List<Recipe> get fetchedRecipes => List.unmodifiable(_fetchedRecipes);

  List<Recipe> get savedRecipes => List.unmodifiable(_savedRecipes);
}
