import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as gemini;
import '../../../core/networking/ServerException.dart';
import '../../../core/services/GeminiApiService.dart';
import '../../../core/services/RecipeApiService.dart';
import 'Recipe.dart';

class RecipeRepository {
  final RecipeApiService apiService;
  final GeminiApiService geminiApiService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RecipeRepository({
    required this.apiService,
    required this.geminiApiService
  });

  Future<List<Recipe>> fetchRecipes(String query) async {
    try {
      // Fetch recipe data from Gemini
      final geminiResponse = await geminiApiService.fetchRecipeFromGemini(query);

      // Validate response
      if (geminiResponse.isEmpty) {
        throw ServerException(
            message: 'No recipe data received from Gemini API',
            statusCode: 404
        );
      }

      // Prepare recipe data with comprehensive error handling
      final recipe = await _processRecipeData(query, geminiResponse, id: null);

      // Additional validation
      if (recipe.name.isEmpty) {
        throw ServerException(
            message: 'Invalid recipe: Missing name',
            statusCode: 400
        );
      }

      return [recipe];
    } on gemini.GenerativeAIException catch (e) {

      if (e.toString().contains('503') || e.toString().contains('UNAVAILABLE')) {
        throw ServerException(
            message: 'AI service is currently overloaded. Please try again later.',
            statusCode: 503
        );
      }
      throw ServerException(
          message: 'Generative AI error: ${e.toString()}',
          statusCode: 500
      );
    } on ServerException {
      rethrow;
    } catch (e) {

      throw ServerException(
          message: 'Unexpected error fetching recipes: ${e.toString()}',
          statusCode: 500
      );
    }
  }

  Future<Recipe> _processRecipeData(String query,
      Map<String, dynamic> geminiResponse,{String? id}) async {
    try {
      // Fetch recipe image with fallback
      String imageUrl = await apiService.fetchRecipeImage(query) ??
          'https://via.placeholder.com/300x200?text=Recipe+Image';

      // Process ingredients with images
      final ingredients = await _processIngredientsWithImages(
          geminiResponse['ingredients'] ?? []
      );

      return Recipe.fromJson({
        'id' : id,
        'name': geminiResponse['name'] ?? 'Unknown Dish',
        'summary': geminiResponse['summary'] ?? 'No summary available',
        'typeOfMeal': geminiResponse['typeOfMeal'] ?? 'General',
        'time': geminiResponse['time'] ?? 'N/A',
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'nutrition': _processNutrition(geminiResponse['nutrition']),
        'directions': _processDirections(geminiResponse['directions']),
        'generatedAt': DateTime.now().toIso8601String(),
        'sourceQuery': query
      });
    } catch (e) {
      print('Recipe Processing Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _processIngredientsWithImages(
      List<dynamic> ingredients
      ) async {
    final List<Map<String, dynamic>> processedIngredients = [];

    for (var ingredient in ingredients) {
      try {
        final ingredientName = ingredient['name'] ?? 'Unnamed Ingredient';
        final imageUrl = await apiService.fetchIngredientImage(ingredientName) ??
            'https://via.placeholder.com/100x100?text=Ingredient';

        processedIngredients.add({
          ...ingredient,
          'name': ingredientName,
          'imageUrl': imageUrl,
        });
      } catch (e) {
        print('Ingredient Processing Error: $e');
        // Continue processing other ingredients
      }
    }

    return processedIngredients;
  }

  Map<String, dynamic> _processNutrition(dynamic nutritionData) {
    try {
      if (nutritionData == null) {
        return Nutrition.defaultValues().toJson();
      }

      return Nutrition(
          calories: nutritionData['calories'] ?? 0,
          protein: nutritionData['protein'] ?? 0,
          carbs: nutritionData['carbs'] ?? 0,
          fat: nutritionData['fat'] ?? 0,
          vitamins: nutritionData['vitamins'] ?? ''
      ).toJson();
    } catch (e) {
      print('Nutrition Processing Error: $e');
      return Nutrition.defaultValues().toJson();
    }
  }

  Map<String, dynamic> _processDirections(dynamic directionsData) {
    try {
      if (directionsData == null) {
        return Directions.defaultValues().toJson();
      }

      return Directions(
          firstStep: directionsData['firstStep'] ?? '',
          secondStep: directionsData['secondStep'] ?? '',
          additionalSteps: directionsData['additionalSteps'] ?? []
      ).toJson();
    } catch (e) {
      print('Directions Processing Error: $e');
      return Directions.defaultValues().toJson();
    }
  }

  Future<void> saveRecipes(List<Recipe> recipes) async {
    try {
      print('Repository: Attempting to save ${recipes.length} recipes');

      if (recipes.isEmpty) {
        print('Repository: No recipes to save');
        throw Exception('No recipes to save');
      }

      String userId;
      if (_auth.currentUser == null) {
        print('Repository: User not authenticated');
        throw Exception('User not authenticated');
      } else {
        userId = _auth.currentUser!.uid;
        print('Repository: User ID - $userId');
      }

      WriteBatch batch = _firestore.batch();

      for (var recipe in recipes) {
        // Additional validation
        if (recipe.id == null || recipe.name == null) {
          print('Repository: Skipping invalid recipe: ${recipe.name}');
          continue;
        }

        DocumentReference recipeDoc = _firestore.collection('recipesGemini').doc();

        batch.set(recipeDoc, {
          ...recipe.toJson(),
          'userId': userId,
          'savedAt': FieldValue.serverTimestamp(),
          'isGenerated': true
        });
      }

      print('Repository: Committing batch');
      await batch.commit();
      print('Repository: Batch committed successfully');
    } on FirebaseException catch (e) {
      print('Repository: Firebase Save Recipes Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      print('Repository: Save Recipes Error: $e');
      print('Repository: Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Recipe>> fetchSavedRecipes() async {
    try {
      String userId = _auth.currentUser!.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('recipesGemini')
          .where('userId', isEqualTo: userId)
          .where('isArchived', isEqualTo: false)
          .get();

      return querySnapshot.docs.map((doc) {
        return Recipe.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Fetch Saved Recipes Error: $e');
      return [];
    }
  }

  Future<void> performCompleteCleanup({
    bool deleteGenerated = true,
    bool archiveOld = true,
    int daysOld = 30
  }) async {
    try {
      String userId = _auth.currentUser!.uid;
      DateTime cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      WriteBatch batch = _firestore.batch();

      // Query for recipes to clean up
      QuerySnapshot querySnapshot = await _firestore
          .collection('recipesGemini')
          .where('userId', isEqualTo: userId)
          .where('generatedAt', isLessThan: cutoffDate.toIso8601String())
          .get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (deleteGenerated && data['isGenerated'] == true) {
          // Completely delete generated recipes
          batch.delete(doc.reference);
        } else if (archiveOld) {
          // Soft archive other old recipes
          batch.update(doc.reference, {
            'isArchived': true,
            'archivedAt': FieldValue.serverTimestamp()
          });
        }
      }

      await batch.commit();
    } catch (e) {
      print('Comprehensive Cleanup Error: $e');
      rethrow;
    }
  }

}


// Enhanced Extensions
extension RecipeExtension on Recipe {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'summary': summary,
      'typeOfMeal': typeOfMeal,
      'time': time,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'nutrition': nutrition,
      'directions': directions,
    };
  }
}