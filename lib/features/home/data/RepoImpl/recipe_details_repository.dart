
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../gemini_integrate/data/Recipe.dart';

class RecipeDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Recipe> getRecipeDetails(String recipeId) async {
    try {
      // Get current user ID
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        throw AuthenticationException('User not authenticated');
      }

      // Reference to the user document
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      // Check if user document exists
      if (!userDoc.exists) {
        throw DataNotFoundException('User document not found');
      }

      // Get the recipes field
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> recipes = userData['recipes'] ?? [];

      // Find the specific recipe
      Map<String, dynamic>? recipeData = recipes.firstWhere(
            (recipe) => recipe['id'] == recipeId,
        orElse: () => null,
      );

      if (recipeData == null) {
        throw DataNotFoundException('Recipe not found');
      }

      // Convert the recipe data to a Recipe object
      return _mapToRecipe(recipeData);
    } catch (e) {
      print('Error fetching recipe details: $e');
      rethrow;
    }
  }

  // Helper method to convert map to Recipe object
  Recipe _mapToRecipe(Map<String, dynamic> recipeData) {
    return Recipe(
      name: recipeData['name'] ?? '',
      summary: recipeData['summary'] ?? '',
      imageUrl: recipeData['imageUrl'] ?? '',
      time: recipeData['time'] ?? 0,
      typeOfMeal: recipeData['typeOfMeal'] ?? '',

      // Directions mapping
      directions: Directions(
        firstStep: recipeData['directions']?['firstStep'] ?? '',
        secondStep: recipeData['directions']?['secondStep'] ?? '',
        additionalSteps: List<String>.from(
            recipeData['directions']?['additionalSteps'] ?? []
        ),
      ),

      // Ingredients mapping
      ingredients: (recipeData['ingredients'] as List?)?.map((ingredientData) {
        return Ingredient(
          name: ingredientData['name'] ?? '',
          quantity: ingredientData['quantity'] ?? 0,
          unit: ingredientData['unit'] ?? '',
          imageUrl: ingredientData['imageUrl'] ?? '',
        );
      }).toList() ?? [],

      // Nutrition mapping
      nutrition: Nutrition(
        protein: recipeData['nutrition']?['protein'] ?? 0,
        carbs: recipeData['nutrition']?['carb'] ?? 0,
        fat: recipeData['nutrition']?['fat'] ?? 0,
        calories: recipeData['nutrition']?['kcal'] ?? 0,
        vitamins: List<String>.from(
            recipeData['nutrition']?['vitamins'] ?? []
        ),
      ),
    );
  }
}

// Custom exceptions for better error handling
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class DataNotFoundException implements Exception {
  final String message;
  DataNotFoundException(this.message);

  @override
  String toString() => 'DataNotFoundException: $message';
}