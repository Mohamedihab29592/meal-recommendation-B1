import '../../../gemini_integrate/data/Recipe.dart';

abstract class HomeRepo{
  Future<void> addIngredients( Recipe recipe);
  Future<bool> checkRecipeIngredientsAdded(String? imageUrl);

}