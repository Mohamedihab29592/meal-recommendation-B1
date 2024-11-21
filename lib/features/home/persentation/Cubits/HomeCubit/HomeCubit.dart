import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import 'HomeState.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());

  List<Recipe> homeRecipes = [];

  Future<void> getdata() async {
    emit(IsLoadingHome());
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Convert the recipes data to List<Recipe>
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey("recipes")) {
          homeRecipes = (userData["recipes"] as List)
              .map((recipeData) {
            // Ensure recipeData is a Map and include the ID
            Map<String, dynamic> recipeMap = Map<String, dynamic>.from(recipeData);

            // Add ID to the recipe map if not already present
            if (!recipeMap.containsKey('id')) {
              recipeMap['id'] = ''; // Or generate a unique ID if needed
            }

            return Recipe.fromJson(recipeMap);
          })
              .toList();
        } else {
          homeRecipes = []; // Initialize empty if no recipes
        }

        print('Fetched recipes: $homeRecipes'); // Debug print

        emit(SuccessState(homeRecipes));
      } else {
        homeRecipes = []; // Initialize if the document doesn't exist
        emit(SuccessState([]));
      }
    } catch (e) {
      print('Error fetching data: $e'); // Debug print
      emit(FailureState(errorMessage: "$e"));
    }
  }

  Future<void> deleteRecipe(String id) async {
    emit(IsLoadingHome());
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(userId);
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

        List<Recipe> recipes = userData != null && userData.containsKey("recipes")
            ? (userData["recipes"] as List)
            .map((recipeData) {
          // Ensure recipeData is a Map and include the ID
          Map<String, dynamic> recipeMap = Map<String, dynamic>.from(recipeData);

          // Add ID to the recipe map if not already present
          if (!recipeMap.containsKey('id')) {
            recipeMap['id'] = ''; // Or generate a unique ID if needed
          }

          return Recipe.fromJson(recipeMap);
        })
            .toList()
            : [];

        recipes.removeWhere((recipe) => recipe.id == id);

        // Convert recipes back to a list of maps for Firestore
        List<Map<String, dynamic>> recipesData =
        recipes.map((recipe) => recipe.toJson()).toList();

        await userDoc.update({"recipes": recipesData});

        // Directly update the state after deletion
        homeRecipes = recipes;
        emit(SuccessState(homeRecipes));
      } else {
        emit(FailureState(errorMessage: "User document does not exist."));
      }
    } catch (e) {
      emit(FailureState(errorMessage: 'Failed to delete recipe: $e'));
    }
  }
}

