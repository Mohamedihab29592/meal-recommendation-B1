import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/ServerException.dart';
import '../../data/Recipe.dart';
import '../../data/RecipeRepository.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  // Use mutable lists with proper state management
  List<Recipe> _fetchedRecipes = [];
  List<Recipe> _savedRecipes = [];

  RecipeBloc({required this.recipeRepository}) : super(RecipeInitial()) {
    // Initialize lists and load initial saved recipes
    _loadInitialSavedRecipes();

    // Register event handlers
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SaveRecipesEvent>(_onSaveRecipes);
    on<LoadSavedRecipesEvent>(_onLoadSavedRecipes);
    on<CombineRecipesEvent>(_onCombineRecipes);
    on<CleanupRecipesEvent>(_onCleanupRecipes);
  }

  Future<void> _loadInitialSavedRecipes() async {
    try {
      final initialSavedRecipes = await recipeRepository.fetchSavedRecipes();
      _savedRecipes = _validateRecipes(initialSavedRecipes);
    } catch (e) {
      print('Failed to load initial saved recipes: $e');
    }
  }

  Future<void> _onFetchRecipes(
      FetchRecipesEvent event, Emitter<RecipeState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(RecipeError("Please enter a valid recipe search query.", false));
      return;
    }

    emit(RecipeLoading());

    try {
      final newRecipes = await recipeRepository.fetchRecipes(event.query);

      if (newRecipes.isEmpty) {
        emit(RecipeError(
            "No recipes found for '${event.query}'. Try a different search term.",
            true));
        return;
      }

      final validRecipes = _validateRecipes(newRecipes);

      // Replace instead of adding to maintain state consistency
      _fetchedRecipes = validRecipes;

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
      // Validate recipes to save
      if (_fetchedRecipes.isEmpty) {
        emit(RecipeError("No valid recipes to save", false));
        return;
      }

      // Save recipes to repository
      await recipeRepository.saveRecipes(_fetchedRecipes);

      _savedRecipes =
          _removeDuplicateRecipes([..._savedRecipes, ..._fetchedRecipes]);

      // Clear fetched recipes after saving
      _fetchedRecipes = [];

      // Emit saved recipes state
      emit(SavedRecipesLoaded(_savedRecipes));
    } catch (e) {
      emit(RecipeError("Failed to save recipes: $e", true));
    }
  }

  Future<void> _onLoadSavedRecipes(
      LoadSavedRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      emit(RecipeLoading());
      final savedRecipes = await recipeRepository.fetchSavedRecipes();
      _savedRecipes = _validateRecipes(savedRecipes);
      emit(SavedRecipesLoaded(_savedRecipes));
    } catch (e) {
      emit(RecipeError("Failed to load saved recipes: $e", true));
    }
  }

  Future<void> _onCombineRecipes(
      CombineRecipesEvent event, Emitter<RecipeState> emit) async {
    final combinedRecipes =
        _removeDuplicateRecipes([..._savedRecipes, ..._fetchedRecipes]);
    print("COMBINED LIST $combinedRecipes");
    emit(RecipeLoaded(combinedRecipes));
  }

  Future<void> _onCleanupRecipes(
      CleanupRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      emit(RecipeLoading());
      await recipeRepository.performCompleteCleanup(
        deleteGenerated: event.deleteGenerated,
        archiveOld: event.archiveOld,
        daysOld: event.daysOld,
      );

      final updatedRecipes = await recipeRepository.fetchSavedRecipes();
      _savedRecipes = _validateRecipes(updatedRecipes);

      emit(SavedRecipesLoaded(_savedRecipes));
    } catch (e) {
      emit(RecipeError('Failed to cleanup recipes: $e', true));
    }
  }

  List<Recipe> _removeDuplicateRecipes(List<Recipe> recipes) {
    final uniqueRecipes = <Recipe>[];
    final seenRecipes = <String>{}; // Set

    for (final recipe in recipes) {
      final identifier = recipe.id ?? recipe.name;
      if (!seenRecipes.contains(identifier)) {
        uniqueRecipes.add(recipe);
        seenRecipes.add(identifier);
      }
    }

    return uniqueRecipes;
  }

  List<Recipe> _validateRecipes(List<Recipe> recipes) {
    return recipes
        .where((recipe) =>
            recipe.name.trim().isNotEmpty && recipe.ingredients.isNotEmpty)
        .toList();
  }

  void clearFetchedRecipes() {
    _fetchedRecipes = [];
    add(CombineRecipesEvent());
  }

  void clearSavedRecipes() {
    _savedRecipes = [];
    add(CombineRecipesEvent());
  }

  List<Recipe> get fetchedRecipes => List.unmodifiable(_fetchedRecipes);

  List<Recipe> get savedRecipes => List.unmodifiable(_savedRecipes);

  @override
  void onTransition(Transition<RecipeEvent, RecipeState> transition) {
    print('Bloc Transition: ${transition.currentState} -> ${transition.nextState}');
    super.onTransition(transition);
  }
}
