import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsState.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import '../../../data/RepoImpl/recipe_details_repository.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final RecipeDetailsRepository _repository;

  DetailsCubit(this._repository) : super(InitialState());

  Future<void> fetchRecipeDetails(String recipeId) async {
    try {
      emit(LoadingState());

      final recipe = await _repository.getRecipeDetails(recipeId);

      emit(LoadedState(recipe: recipe));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}