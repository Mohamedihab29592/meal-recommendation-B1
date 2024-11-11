import '../../../core/services/GeminiApiService.dart';
import '../../../core/services/RecipeApiService.dart';
import 'Recipe.dart';

class RecipeRepository {
  final RecipeApiService apiService;
  final GeminiApiService geminiApiService;

  RecipeRepository({required this.apiService, required this.geminiApiService});

  Future<List<Recipe>> fetchRecipes(String query) async {
    try {
      // Fetch recipe data from Gemini
      final geminiResponse = await geminiApiService.fetchRecipeFromGemini(query);

      // Check if geminiResponse or recipeData is null
      if (geminiResponse['name'] == null) {
        print('No recipe data found from Gemini');
        return [];  // Return an empty list if no recipe data is found
      }

      // Prepare the recipe data structure
      var recipeData = {
        'name': geminiResponse['name'] ?? 'Unknown Dish',
        'description': geminiResponse['description'] ?? 'No description available',
        'imageUrl': await apiService.fetchRecipeImage(query),  // Get recipe image URL from Pexels
        'ingredients': await _getIngredientsWithImages(geminiResponse['ingredients']),
        'instructions': geminiResponse['instructions'] ?? [],
        'nutrition': geminiResponse['nutrition'] ?? {}
      };

      // Return the recipe object
      return [Recipe.fromJson(recipeData)];

    } catch (e) {
      print('Error fetching recipes or images: $e');
      return [];  // Return an empty list on error
    }
  }

  // Helper method to fetch ingredient images
  Future<List<Map<String, dynamic>>> _getIngredientsWithImages(List<dynamic> ingredients) async {
    final List<Map<String, dynamic>> ingredientsWithImages = [];

    // For each ingredient, fetch the image URL
    for (var ingredient in ingredients) {
      final ingredientName = ingredient['name'] as String;
      final imageUrl = await apiService.fetchIngredientImage(ingredientName);
      ingredient['imageUrl'] = imageUrl ?? 'default_image_url'; // Provide a fallback URL if null
      ingredientsWithImages.add(ingredient);
    }

    return ingredientsWithImages;
  }
}
