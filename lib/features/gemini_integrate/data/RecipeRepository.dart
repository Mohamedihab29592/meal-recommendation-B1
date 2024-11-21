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
      User? currentUser  = _auth.currentUser ;
      if (currentUser  == null) {
        throw Exception('User  must be signed in to save recipes');
      }
      print('Repository: Attempting to save ${recipes.length} recipes');

      if (recipes.isEmpty) {
        print('Repository: No recipes to save');
        throw Exception('No recipes to save');
      }

      String userId = currentUser .uid; // Directly get userId from currentUser
      print('Repository: User ID - $userId');

      DocumentReference userDoc = _firestore.collection('users').doc(userId);

      // Prepare the recipes to be added
      List<Map<String, dynamic>> recipesToAdd = [];
      for (var recipe in recipes) {
        // Additional validation
        if (recipe.id == null || recipe.name == null) {
          print('Repository: Skipping invalid recipe: ${recipe.name}');
          continue;
        }

        // Convert recipe to JSON format
        recipesToAdd.add({
          ...recipe.toJson(),
          'userId': userId,
          'isGenerated': true,
          'isArchived': false,
        });
      }

      if (recipesToAdd.isNotEmpty) {
        await userDoc.update({
          'recipesGemini': FieldValue.arrayUnion(recipesToAdd),
        });

        for (var recipe in recipesToAdd) {
          await userDoc.update({
            'recipesGemini': FieldValue.arrayUnion([
              {
                ...recipe,
                'savedAt': FieldValue.serverTimestamp(),
              }
            ]),
          });
        }

        print('Repository: Recipes saved successfully');
      } else {
        print('Repository: No valid recipes to save');
      }
    } on FirebaseException catch (e) {
      print('Repository: Firebase Save Recipes Error: ${e.code} - ${e.message}');

      // More detailed error handling
      if (e.code == 'permission-denied') {
        throw Exception('You do not have permission to save recipes. Please check your authentication.');
      }

      rethrow;
    } catch (e, stackTrace) {
      print('Repository: Save Recipes Error: $e');
      print('Repository: Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Recipe>> fetchSavedRecipes() async {
    try {
      User? currentUser  = _auth.currentUser ;
      if (currentUser  == null) {
        throw Exception('User  must be signed in to fetch recipes');
      }

      String userId = currentUser .uid;
      print('Fetching recipes for user ID: $userId');

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        List<dynamic> recipesData = userDoc.get('recipesGemini') ?? [];
        List<Recipe> recipes = recipesData.map((data) => Recipe.fromJson(data)).toList();
        print('Fetched ${recipes.length} recipes');

        List<Recipe> savedRecipes = recipes.where((recipe) => recipe.isArchived == false).toList();

        return savedRecipes;
      } else {
        print('User  document does not exist');
        return [];
      }
    } on FirebaseException catch (e) {
      print('Error fetching user recipes: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error fetching user recipes: $e');
      rethrow;
    }
  }

  Future<void> performCompleteCleanup({
    bool deleteGenerated = true,
    bool archiveOld = true,
    int daysOld = 30,
  }) async {
    try {
      User? currentUser  = _auth.currentUser ;
      if (currentUser  == null) {
        print('Cleanup Error: No authenticated user');
        throw Exception('User  must be authenticated to perform cleanup');
      }

      String userId = currentUser .uid;

      if (daysOld <= 0) {
        print('Invalid days old parameter: $daysOld');
        return;
      }

      DocumentReference userDoc = _firestore.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        print('Cleanup Error: User document does not exist');
        return;
      }

      // Access the recipesGemini array
      List<dynamic> recipesGemini = userSnapshot.get('recipesGemini') ?? [];
      WriteBatch batch = _firestore.batch();
      int batchOperationsCount = 0;
      int maxBatchOperations = 500;

      int deleteCount = 0;
      int archiveCount = 0;

      for (var recipe in recipesGemini) {
        if (recipe is Map<String, dynamic>) {

          try {
            if (deleteGenerated && (recipe['isGenerated'] == true)) {
              batch.update(userDoc, {
                'recipesGemini': FieldValue.arrayRemove([recipe]),
              });
              deleteCount++;
            } else if (archiveOld) {
              Map<String, dynamic> updatedRecipe = {
                ...recipe,
                'isArchived': true,
              };

              // Remove the old recipe and add the updated one
              batch.update(userDoc, {
                'recipesGemini': FieldValue.arrayRemove([recipe]),
              });
              batch.update(userDoc, {
                'recipesGemini': FieldValue.arrayUnion([updatedRecipe]),
              });
              archiveCount++;
            }

            batchOperationsCount++;

            // Commit batch when it reaches max operations
            if (batchOperationsCount >= maxBatchOperations) {
              await batch.commit();
              batch = _firestore.batch();
              batchOperationsCount = 0;
            }
          } catch (e) {
            print('Error processing individual recipe during cleanup: $e');
          }
        }
      }

      if (batchOperationsCount > 0) {
        await batch.commit();
      }

      print('Cleanup complete: Deleted $deleteCount, Archived $archiveCount recipes');
    } on FirebaseException catch (e) {
      print('Firebase Cleanup Error: ${e.code} - ${e.message}');
      rethrow;
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