import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utiles/local_storage_service.dart';
import '../../../../auth/login/domain/entity/user_entity.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import 'HomeState.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());

  List<Recipe> homeRecipes = [];
  List<Recipe> favoriteRecipes = [];

  Future<void> getdata() async {
    emit(IsLoadingHome());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        homeRecipes = (userData?["recipes"] as List<dynamic>? ?? [])
            .map((recipeData) => Recipe.fromJson(
            Map<String, dynamic>.from(recipeData as Map)))
            .toList();

        updateFavoriteRecipes(); // Ensure favorites are updated
      } else {
        emit(HomeLoaded(homeRecipes: [], favoriteRecipes: favoriteRecipes));
      }
    } catch (e) {
      emit(FailureState(errorMessage: "Error fetching recipes: $e"));
    }
  }

  Future<void> deleteRecipe(String id) async {
    emit(IsLoadingHome());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      final userDoc = FirebaseFirestore.instance.collection("users").doc(userId);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>?;

        final recipes = (userData?["recipes"] as List<dynamic>? ?? [])
            .map((recipeData) => Recipe.fromJson(
            Map<String, dynamic>.from(recipeData as Map)))
            .toList();

        recipes.removeWhere((recipe) => recipe.id == id);

        await userDoc.update({
          "recipes": recipes.map((recipe) => recipe.toJson()).toList()
        });

        homeRecipes = recipes;
        updateFavoriteRecipes(); // Ensure favorites are also updated
      } else {
        emit(FailureState(errorMessage: "User document does not exist."));
      }
    } catch (e) {
      emit(FailureState(errorMessage: "Failed to delete recipe: $e"));
    }
  }

  Future<void> toggleFavoriteLocal(String recipeId) async {
    final favoritesBox = LocalStorageService.getFavoritesBox();

    if (favoritesBox.containsKey(recipeId)) {
      await favoritesBox.delete(recipeId);
    } else {
      await favoritesBox.put(recipeId, recipeId);
    }

    updateFavoriteRecipes();
  }

  void updateFavoriteRecipes() {
    final favoritesBox = LocalStorageService.getFavoritesBox();
    final favoriteIds = favoritesBox.keys.toSet();

    favoriteRecipes = homeRecipes
        .where((recipe) => favoriteIds.contains(recipe.id))
        .toList();

    emit(HomeLoaded(
      homeRecipes: List.from(homeRecipes),
      favoriteRecipes: List.from(favoriteRecipes),
    ));
  }

  bool isFavorite(String recipeId) {
    final favoritesBox = LocalStorageService.getFavoritesBox();
    return favoritesBox.containsKey(recipeId);
  }
}
