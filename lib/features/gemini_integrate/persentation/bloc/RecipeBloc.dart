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
  }

  Future<void> _onFetchRecipes(
      FetchRecipesEvent event,
      Emitter<RecipeState> emit
      ) async {
    emit(RecipeLoading());

    try {
      final newRecipes = await recipeRepository.fetchRecipes(event.query);

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
    try {
      final savedRecipes = await recipeRepository.fetchSavedRecipes();

      emit(SavedRecipesLoaded(savedRecipes));
    } catch (e) {
      emit(RecipeError("Failed to load saved recipes: ${e.toString()}"));
    }
  }
}