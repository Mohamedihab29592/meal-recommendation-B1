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

      // Check if the response contains necessary fields
      if (geminiResponse.isEmpty) {
        print('No data received from Gemini API');
        return [];
      }

      // Prepare the recipe data structure with safe handling for missing fields
      var recipeData = {
        'name': geminiResponse['name'] ?? 'Unknown Dish',
        'summary': geminiResponse['summary'] ?? 'No summary available',
        'typeOfMeal': geminiResponse['typeOfMeal'] ?? 'General',
        'time': geminiResponse['time'] ?? 'N/A',
        'imageUrl': await apiService.fetchRecipeImage(query) ?? 'default_recipe_image_url',
        'ingredients': await _getIngredientsWithImages(geminiResponse['ingredients'] ?? []),
        'nutrition': geminiResponse['nutrition'] ?? Nutrition.defaultValues().toJson(),
        'directions': geminiResponse['directions'] ?? Directions.defaultValues().toJson()
      };

      // Return the recipe object
      return [Recipe.fromJson(recipeData)];
    } catch (e) {
      print('Error fetching recipes or processing data: $e');
      return [] ;
    }
  }

  // Helper method to fetch ingredient images
  Future<List<Map<String, dynamic>>> _getIngredientsWithImages(List<dynamic> ingredients) async {
    final List<Map<String, dynamic>> ingredientsWithImages = [];

    for (var ingredient in ingredients) {
      final ingredientName = ingredient['name'] ?? 'Unnamed Ingredient';
      final imageUrl = await apiService.fetchIngredientImage(ingredientName) ?? 'default_image_url';
      ingredientsWithImages.add({
        ...ingredient,
        'name': ingredientName,
        'imageUrl': imageUrl,
      });
    }

    return ingredientsWithImages;
  }
}

// Extensions for converting objects to JSON
extension NutritionExtension on Nutrition {
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'vitamins': vitamins,
    };
  }
}

extension DirectionsExtension on Directions {
  Map<String, dynamic> toJson() {
    return {
      'firstStep': firstStep,
      'secondStep': secondStep,
      'additionalSteps': additionalSteps,
    };
  }
}
