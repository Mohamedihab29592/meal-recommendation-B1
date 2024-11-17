import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/domain/HomeRepo/HomeRepo.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/ImageCubit.dart';

import '../../../gemini_integrate/data/Recipe.dart';

class HomeRepoImpl extends HomeRepo {
  @override
  Future<void> addIngredients(Recipe recipe) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    String userId = currentUser.uid;

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection("users").doc(userId);

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

    return userDoc.update({
      "recipes": FieldValue.arrayUnion([recipeData])
    }).catchError((error) {
      print("Failed to add recipe: $error");
    });
  }
}

