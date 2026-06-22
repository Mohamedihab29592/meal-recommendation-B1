import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/features/home/domain/HomeRepo/HomeRepo.dart';
import '../../../gemini_integrate/data/Recipe.dart';

class HomeRepoImpl extends HomeRepo {
  final FirebaseFirestore _firestore;
  final String userId;

  HomeRepoImpl(this._firestore, this.userId);
  @override
  Future<void> addIngredients(Recipe recipe) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is logged in.");
      }

      String userId = currentUser.uid;

      DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(userId);

      // Validate recipe before adding
      _validateRecipe(recipe);

      // Create a new recipe object to add
      Map<String, dynamic> recipeData = {
        "id": FirebaseFirestore.instance.collection("users").doc().id,
        "name": recipe.name,
        "summary": recipe.summary,
        "typeOfMeal": recipe.typeOfMeal,
        "time": recipe.time,
        "imageUrl": recipe.imageUrl,
        "ingredients": recipe.ingredients
            .map((ingredient) => {
          "name": ingredient.name,
          "quantity": ingredient.quantity,
          "unit": ingredient.unit,
          "imageUrl": ingredient.imageUrl,
        })
            .toList(),
        "nutrition": {
          "calories": recipe.nutrition.calories,
          "protein": recipe.nutrition.protein,
          "carbs": recipe.nutrition.carbs,
          "fat": recipe.nutrition.fat,
          "vitamins": recipe.nutrition.vitamins,
        },
        "directions": {
          "firstStep": recipe.directions.firstStep,
          "secondStep": recipe.directions.secondStep,
          "additionalSteps": recipe.directions.additionalSteps,
        }
      };

      // Check if recipes field exists, if not, create it
      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData == null || !userData.containsKey('recipes')) {
        // If recipes field doesn't exist, set it instead of updating
        await userDoc.set({
          'recipes': [recipeData]
        }, SetOptions(merge: true));
      } else {
        // If recipes field exists, use arrayUnion
        await userDoc.update({
          "recipes": FieldValue.arrayUnion([recipeData])
        });
      }
    } catch (error) {
      print("Failed to add recipe: $error");
      rethrow; // Re-throw to allow caller to handle the error
    }
  }

  // Optional: Add validation method
  void _validateRecipe(Recipe recipe) {
    if (recipe.name.trim().isEmpty) {
      throw ArgumentError("Recipe name cannot be empty");
    }
    if (recipe.imageUrl.trim().isEmpty) {
      throw ArgumentError("Recipe Image cannot be empty");
    }


    if (recipe.typeOfMeal.trim().isEmpty) {
      throw ArgumentError("Recipe Type cannot be empty");
    }

    if (recipe.ingredients.isEmpty) {
      throw ArgumentError("Recipe must have at least one ingredient");
    }

    if (recipe.directions.firstStep.trim().isEmpty) {
      throw ArgumentError("First step of recipe cannot be empty");
    }
  }


  @override
  Future<bool> checkRecipeIngredientsAdded(String? imageUrl) async {
    if (imageUrl == null) return false;

    try {
      // Fetch the user document
      final userDoc = await _firestore.collection('users').doc(userId).get();

      // Check if the document exists
      if (!userDoc.exists) {
        print('User  document does not exist.');
        return false;
      }

      List<dynamic>? recipes = userDoc.data()?['recipes'];

      if (recipes != null) {
        for (var recipe in recipes) {
          if (recipe is Map<String, dynamic>) {
            if ((recipe['imageUrl'] == imageUrl)) {
              return true;
            }
          }
        }
      }

      return false; // No match found
    } catch (error) {
      print('Error checking recipe existence: $error');
      return false;
    }
  }

  }


