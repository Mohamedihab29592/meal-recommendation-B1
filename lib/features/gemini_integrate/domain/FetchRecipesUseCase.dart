import '../data/Recipe.dart';
import '../data/RecipeRepository.dart';

class FetchRecipesUseCase {
  final RecipeRepository repository;

  FetchRecipesUseCase({required this.repository});

  Future<List<Recipe>> execute(String query) async {
    return await repository.fetchRecipes(query);
  }
}