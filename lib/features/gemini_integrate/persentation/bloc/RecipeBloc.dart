import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/ServerException.dart';
import '../../data/Recipe.dart';
import '../../data/RecipeRepository.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      print('Initial saved recipes loaded: ${_savedRecipes.length}');
    } catch (e) {
      print('Failed to load initial saved recipes: $e');
    }
  }
  Future<void> _onFetchRecipes(
      FetchRecipesEvent event, Emitter<RecipeState> emit) async {
    print('Fetching recipes for query: ${event.query}');

    if (event.query.trim().isEmpty) {
      print('Empty query provided');
      emit(RecipeError("Please enter a valid recipe search query.", false));
      return;
    }

    emit(RecipeLoading());

    try {
      // Fetch new recipes from the repository
      final newRecipes = await recipeRepository.fetchRecipes(event.query);

      print('Raw fetched recipes count: ${newRecipes.length}');

      if (newRecipes.isEmpty) {
        print('No recipes found for query');
        emit(RecipeError(
            "No recipes found for '${event.query}'. Try a different search term.",
            true));
        return;
      }

      // Validate the fetched recipes
      final validRecipes = _validateRecipes(newRecipes);

      print('Valid recipes count after validation: ${validRecipes.length}');

      // Log details of valid recipes
      for (var recipe in validRecipes) {
        print(
            'Fetched Recipe: ${recipe.name}, Ingredients: ${recipe.ingredients.length}');
      }

      // Append valid recipes to the existing list
      _fetchedRecipes.addAll(validRecipes);

      print('_fetchedRecipes after appending: ${_fetchedRecipes.length}');

      // Emit the updated list of recipes
      emit(RecipeLoaded(List.from(_fetchedRecipes)));
    } on ServerException catch (e) {
      print('Server Exception during fetch: ${e.message}');
      emit(RecipeError(e.message, true));
    } catch (e) {
      print('Unexpected error during fetch: $e');
      emit(RecipeError("An unexpected error occurred: $e", true));
    }
  }

  Future<void> _onSaveRecipes(
      SaveRecipesEvent event, Emitter<RecipeState> emit) async {
    try {

      // Check authentication before saving
      if (_auth.currentUser == null) {
        emit(RecipeError("Please log in to save recipes", false));
        return;
      }

      final recipesToSave = event.recipesToSave.isNotEmpty
          ? event.recipesToSave
          : _fetchedRecipes;

      if (recipesToSave.isEmpty) {
        emit(RecipeError("No valid recipes to save", false));
        return;
      }

      await recipeRepository.saveRecipes(recipesToSave);

      _savedRecipes = _removeDuplicateRecipes([..._savedRecipes, ...recipesToSave]);

      emit(SavedRecipesLoaded(_savedRecipes));
    } catch (e) {
      String errorMessage = 'Failed to save recipes';

      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please log in or check your account.';
      }

      emit(RecipeError(errorMessage, true));
    }
  }

  Future<void> _onLoadSavedRecipes(
      LoadSavedRecipesEvent event, Emitter<RecipeState> emit) async {
    try {
      // Check authentication before loading saved recipes
      if (_auth.currentUser == null) {
        emit(RecipeError("Please log in to view saved recipes", false));
        return;
      }

      // Emit loading state
      emit(RecipeLoading());

      // Fetch saved recipes
      final savedRecipes = await recipeRepository.fetchSavedRecipes();

      // Validate and process recipes
      if (savedRecipes.isEmpty) {
        // No saved recipes found
        emit(NoSavedRecipes());
        return;
      }

      // Validate and clean recipes
      _savedRecipes = _validateRecipes(savedRecipes);

      // Emit loaded state with validated recipes
      emit(RetrieveRecipesLoaded(_savedRecipes));
    }  catch (e) {
      // Generic error handling
      String errorMessage = 'Unexpected error loading saved recipes';

      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please log in or check your account.';
      }

      emit(RecipeError(errorMessage, true));
    }
  }

  Future<void> _onCombineRecipes(
      CombineRecipesEvent event, Emitter<RecipeState> emit) async {
    final combinedRecipes =
        _removeDuplicateRecipes([..._fetchedRecipes]);
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
      emit(RecipeLoading());
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
      final identifier = recipe.name ?? recipe.name;
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
