
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
      return Recipe.fromJson(recipeData);
    } catch (e) {
      print('Error fetching recipe details: $e');
      rethrow;
    }
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