import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../../../home/persentation/Cubits/HomeCubit/HomeState.dart';
import '../../domain/usecases/delete_favorite_use_case.dart';
import '../../domain/usecases/get_all_favorites_use_case.dart';
import '../../domain/usecases/save_favorite_use_case.dart';

import 'favorites_state.dart';

class FavoritesBloc extends Cubit<FavoritesState> {
  final SaveFavoriteUseCase saveFavoriteUseCase;
  final DeleteFavoriteUseCase deleteFavoriteUseCase;
  final GetAllFavoritesUseCase getAllFavoritesUseCase;

  FavoritesBloc(
      this.saveFavoriteUseCase,
      this.deleteFavoriteUseCase,
      this.getAllFavoritesUseCase)
      : super(FavoritesInitial()) {
  }
  Future<void> getFavoriteRecipes() async {
    emit(FavoritesLoading());
    try {
      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(GetAllFavoritesError( "No user is logged in."));
        return;
      }

      // Fetch the user's document
      DocumentReference userDoc = FirebaseFirestore.instance.collection("users").doc(userId);
      DocumentSnapshot snapshot = await userDoc.get();

      if (!snapshot.exists) {
        emit(GetAllFavoritesError( "User document does not exist."));
        return;
      }

      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      List<Recipe> recipes = userData != null && userData.containsKey("recipes")
          ? (userData["recipes"] as List).map((recipeData) {
        // Convert Firestore recipe data to Recipe objects
        Map<String, dynamic> recipeMap = Map<String, dynamic>.from(recipeData);
        return Recipe.fromJson(recipeMap);
      }).toList()
          : [];

      // Filter favorite recipes
      List<Recipe> favoriteRecipes = recipes.where((recipe) => recipe.isFavorite == true).toList();

      // Emit the favorite recipes
      emit(GetAllFavoritesDone(favoriteRecipes));
    } catch (e) {
      emit(GetAllFavoritesError('Failed to fetch favorite recipes: $e'));
    }
  }
}
