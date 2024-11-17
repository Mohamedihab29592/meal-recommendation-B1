import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/Recipe.dart';
import '../../domain/FetchRecipesUseCase.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final FetchRecipesUseCase fetchRecipesUseCase;
  final List<Recipe> _recipeList = []; // Maintain a list of all recipes

  RecipeBloc({required this.fetchRecipesUseCase}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      emit(RecipeLoading());

      try {
        // Fetch the new recipe from the use case
        final newRecipe = await fetchRecipesUseCase.execute(event.query);

        // Add the new recipe to the list
        _recipeList.addAll(newRecipe);

        // Emit the updated list with old and new data
        emit(RecipeLoaded(List<Recipe>.from(_recipeList)));
            } catch (e) {
        emit(RecipeError("Failed to load recipes: ${e.toString()}"));
      }
    });
  }
}