import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utiles/local_storage_service.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import 'HomeEvent.dart';
import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HomeBloc({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })
      : _firestore = firestore,
        _auth = auth,
        super(InitialState()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<FilterRecipesEvent>(_onFilterRecipes);
    on<SortRecipesEvent>(_onSortRecipes);
    on<ResetFiltersEvent>(_onResetFilters);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DeleteRecipeEvent>(_onDeleteRecipe);
    on<UpdateFavorite>(_onUpdateFavorite);
  }

  List<Recipe> _homeRecipes = [];
  List<Recipe> _favoriteRecipes = [];
  List<Recipe> _filteredRecipes = [];


  Future<void> _onFetchRecipes(FetchRecipesEvent event, Emitter<HomeState> emit) async {
    // Initial loading state
    emit(IsLoadingHome());
    try {
      // Fetch recipes logic
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      final userDoc = await _firestore.collection("users").doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        _homeRecipes = (userData?["recipes"] as List<dynamic>? ?? [])
            .map((recipeData) =>
            Recipe.fromJson(Map<String, dynamic>.from(recipeData as Map)))
            .toList();

        // Initialize filteredRecipes to all recipes
        _filteredRecipes = List.from(_homeRecipes);
        final favoritesBox = LocalStorageService.getFavoritesBox();
        final favoriteIds = favoritesBox.keys.toSet();

        _favoriteRecipes = _homeRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();

        // Emit the loaded state
        emit(HomeLoaded(
          homeRecipes: _homeRecipes,
          favoriteRecipes: _favoriteRecipes,
          filteredRecipes: _filteredRecipes,
        ));
      } else {
        emit(HomeLoaded(homeRecipes: [], favoriteRecipes: [], filteredRecipes: []));
      }
    } catch (e) {
      emit(FailureState(errorMessage: "Error fetching recipes: $e"));
    }
  }

  void _onFilterRecipes(
      FilterRecipesEvent event,
      Emitter<HomeState> emit,
      ) {
    emit(IsLoadingHome());

    // Apply filters
    _filteredRecipes = _homeRecipes.where((recipe) {
      // Filter by meal type
      if (event.mealType != null && recipe.typeOfMeal != event.mealType) {
        return false;
      }

      /* Uncomment and implement additional filters as needed
    // Filter by cooking time
    if (event.cookingTime != null) {
      switch (event.cookingTime) {
        case 0: // "5 min"
          if (_parseCookingTime(recipe.time) > 5) return false;
          break;
        case 1: // "10 min"
          if (_parseCookingTime(recipe.time) > 10) return false;
          break;
        case 2: // "15+ min"
          if (_parseCookingTime(recipe.time) <= 15) return false;
          break;
      }
    }

    // Filter by calories
    if (event.caloriesRange != null &&
        (recipe.nutrition.calories < event.caloriesRange!.start ||
            recipe.nutrition.calories > event.caloriesRange!.end)) {
      return false;
    }

    // Filter by number of ingredients
    if (event.maxIngredients != null &&
        recipe.ingredients.length > event.maxIngredients!) {
      return false;
    }
    */

      return true;
    }).toList();

    // Check if filtered list is empty
    if (_filteredRecipes.isEmpty) {
      emit(NoMatchingRecipesState());
    } else {
      emit(HomeLoaded(
        homeRecipes: _homeRecipes,
        favoriteRecipes: _favoriteRecipes,
        filteredRecipes: _filteredRecipes,
      ));
    }
  }

  void _onSortRecipes(SortRecipesEvent event,
      Emitter<HomeState> emit,) {
    switch (event.sortBy) {
      case 'calories':
        _filteredRecipes.sort((a, b) =>
        event.ascending
            ? (a.nutrition.calories ?? 0).compareTo(b.nutrition.calories ?? 0)
            : (b.nutrition.calories ?? 0).compareTo(a.nutrition.calories ?? 0));
        break;
      case 'protein':
        _filteredRecipes.sort((a, b) =>
        event.ascending
            ? (a.nutrition.protein ?? 0).compareTo(b.nutrition.protein ?? 0)
            : (b.nutrition.protein ?? 0).compareTo(a.nutrition.protein ?? 0));
        break;
      case 'cookingTime':
        _filteredRecipes.sort((a, b) =>
        event.ascending
            ? (_parseCookingTime(a.time)).compareTo(_parseCookingTime(b.time))
            : (_parseCookingTime(b.time).compareTo(_parseCookingTime(a.time))));
        break;
    }

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
    ));
  }

  void _onResetFilters(ResetFiltersEvent event,
      Emitter<HomeState> emit,) {
    _filteredRecipes = List.from(_homeRecipes);
    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
    ));
  }


  Future<void> _onDeleteRecipe(DeleteRecipeEvent event,
      Emitter<HomeState> emit,) async {
    emit(IsLoadingHome());
    final favoritesBox = LocalStorageService.getFavoritesBox();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      final userDoc = _firestore.collection("users").doc(userId);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final userData = snapshot.data();

        final recipes = (userData?["recipes"] as List<dynamic>? ?? [])
            .map((recipeData) =>
            Recipe.fromJson(Map<String, dynamic>.from(recipeData as Map)))
            .toList();

        recipes.removeWhere((recipe) => recipe.id == event.recipeId);

        await userDoc.update(
            {"recipes": recipes.map((recipe) => recipe.toJson()).toList()});

        _homeRecipes = recipes;
        _filteredRecipes = List.from(_homeRecipes);
        final favoriteIds = favoritesBox.keys.toSet();
        _favoriteRecipes = _homeRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();

        emit(HomeLoaded(
          homeRecipes: _homeRecipes,
          favoriteRecipes: _favoriteRecipes,
          filteredRecipes: _filteredRecipes,
        ));
      } else {
        emit(FailureState(errorMessage: "User document does not exist."));
      }
    } catch (e) {
      emit(FailureState(errorMessage: "Failed to delete recipe: $e"));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<HomeState> emit) async {
    final favoritesBox = LocalStorageService.getFavoritesBox();

    if (favoritesBox.containsKey(event.recipeId)) {
      await favoritesBox.delete(event.recipeId);
    } else {
      await favoritesBox.put(event.recipeId, event.recipeId);
    }

    // Emit the updated favorites state directly
    final favoriteIds = favoritesBox.keys.toSet();
    _favoriteRecipes = _homeRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
    ));
  }


  bool isFavorite(String recipeId) {
    final favoritesBox = LocalStorageService.getFavoritesBox();
    return favoritesBox.containsKey(recipeId);
  }

  int _parseCookingTime(String cookingTime) {
    try {
      return int.parse(cookingTime.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      print("Error parsing cooking time: $cookingTime");
      return 0;
    }
  }



  Future<void> _onUpdateFavorite(UpdateFavorite event,
      Emitter<HomeState> emit,) async {
    {
      final favoritesBox = LocalStorageService.getFavoritesBox();
      final favoriteIds = favoritesBox.keys.toSet();

      _favoriteRecipes = _homeRecipes
          .where((recipe) => favoriteIds.contains(recipe.id))
          .toList();

      emit(HomeLoaded(
        homeRecipes: _homeRecipes,
        favoriteRecipes: _favoriteRecipes,
        filteredRecipes: _filteredRecipes,
      ));
    }
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    print('Bloc Transition: ${transition.currentState} -> ${transition
        .nextState}');
    print('Transition from ${transition.currentState} to ${transition.nextState}');
    print('_homeRecipes: ${_homeRecipes.length}');
    print('_filteredRecipes: ${_filteredRecipes.length}');
    super.onTransition(transition);
  }
}
