
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getRecipeDetails(String recipeId) async {
    try {
      // Get current user ID
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Reference to the user document
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      // Check if user document exists
      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      // Get the recipes field
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> recipes = userData['recipes'] ?? [];

      // Find the specific recipe
      Map<String, dynamic>? recipe = recipes.firstWhere(
            (recipe) => recipe['id'] == recipeId,
        orElse: () => null,
      );

      if (recipe == null) {
        throw Exception('Recipe not found');
      }

      return recipe;
    } catch (e) {
      print('Error fetching recipe details: $e');
      rethrow;
    }
  }
}