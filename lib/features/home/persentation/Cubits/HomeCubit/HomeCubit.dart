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
  })  : _firestore = firestore,
        _auth = auth,
        super(InitialState()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<FilterRecipesEvent>(_onFilterRecipes);
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<SortRecipesEvent>(_onSortRecipes);
    on<ResetFiltersEvent>(_onResetFilters);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DeleteRecipeEvent>(_onDeleteRecipe);
  }

  List<Recipe> _homeRecipes = [];
  List<Recipe> _favoriteRecipes = [];
  List<Recipe> _filteredRecipes = [];

  int _generateUniqueStateId() {
    return DateTime.now().millisecondsSinceEpoch + Random().nextInt(1000);
  }

  Future<void> _onFetchRecipes(
    FetchRecipesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(IsLoadingHome());
    try {
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

        _filteredRecipes = List.from(_homeRecipes);
        _updateFavoriteRecipes();

        emit(HomeLoaded(
          homeRecipes: _homeRecipes,
          favoriteRecipes: _favoriteRecipes,
          filteredRecipes: _filteredRecipes,
          stateId: _generateUniqueStateId(),
        ));
      } else {
        emit(HomeLoaded(
          homeRecipes: [],
          favoriteRecipes: [],
          filteredRecipes: [],
          stateId: _generateUniqueStateId(),
        ));
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
    _filteredRecipes = _homeRecipes.where((recipe) {
      // Comprehensive filtering logic
      if (event.mealType != null && recipe.typeOfMeal != event.mealType) {
        return false;
      }

      // Add more comprehensive filtering conditions
      return true;
    }).toList();

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
      stateId: _generateUniqueStateId(),
    ));
  }

  void _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<HomeState> emit,
  ) {
    _filteredRecipes = _homeRecipes.where((recipe) {
      return recipe.name.toLowerCase().contains(event.query.toLowerCase()) ||
          recipe.summary.toLowerCase().contains(event.query.toLowerCase()) ||
          recipe.typeOfMeal.toLowerCase().contains(event.query.toLowerCase()) ||
          (recipe.ingredients.any((ingredient) => ingredient.name
                  .toLowerCase()
                  .contains(event.query.toLowerCase())) ??
              false);
    }).toList();

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
      stateId: _generateUniqueStateId(),
    ));
  }

  void _onSortRecipes(
    SortRecipesEvent event,
    Emitter<HomeState> emit,
  ) {
    switch (event.sortBy) {
      case 'calories':
        _filteredRecipes.sort((a, b) => event.ascending
            ? (a.nutrition.calories ?? 0).compareTo(b.nutrition.calories ?? 0)
            : (b.nutrition.calories ?? 0).compareTo(a.nutrition.calories ?? 0));
        break;
      case 'protein':
        _filteredRecipes.sort((a, b) => event.ascending
            ? (a.nutrition.protein ?? 0).compareTo(b.nutrition.protein ?? 0)
            : (b.nutrition.protein ?? 0).compareTo(a.nutrition.protein ?? 0));
        break;
      case 'cookingTime':
        _filteredRecipes.sort((a, b) => event.ascending
            ? (int.tryParse(a.time) ?? 0).compareTo(int.tryParse(b.time) ?? 0)
            : (int.tryParse(b.time) ?? 0).compareTo(int.tryParse(a.time) ?? 0));
        break;
    }

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
      stateId: _generateUniqueStateId(),
    ));
  }

  void _onResetFilters(
    ResetFiltersEvent event,
    Emitter<HomeState> emit,
  ) {
    _filteredRecipes = List.from(_homeRecipes);
    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
      stateId: _generateUniqueStateId(),
    ));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    final favoritesBox = LocalStorageService.getFavoritesBox();

    if (favoritesBox.containsKey(event.recipeId)) {
      await favoritesBox.delete(event.recipeId);
    } else {
      await favoritesBox.put(event.recipeId, event.recipeId);
    }

    _updateFavoriteRecipes();

    emit(HomeLoaded(
      homeRecipes: _homeRecipes,
      favoriteRecipes: _favoriteRecipes,
      filteredRecipes: _filteredRecipes,
      stateId: _generateUniqueStateId(),
    ));
  }

  Future<void> _onDeleteRecipe(
    DeleteRecipeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(IsLoadingHome());
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
        _updateFavoriteRecipes();

        emit(HomeLoaded(
          homeRecipes: _homeRecipes,
          favoriteRecipes: _favoriteRecipes,
          filteredRecipes: _filteredRecipes,
          stateId: _generateUniqueStateId(),
        ));
      } else {
        emit(FailureState(errorMessage: "User document does not exist."));
      }
    } catch (e) {
      emit(FailureState(errorMessage: "Failed to delete recipe: $e"));
    }
  }

  void _updateFavoriteRecipes() {
    final favoritesBox = LocalStorageService.getFavoritesBox();
    final favoriteIds = favoritesBox.keys.toSet();

    _favoriteRecipes = _homeRecipes
        .where((recipe) => favoriteIds.contains(recipe.id))
        .toList();
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

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    print('Bloc Transition: ${transition.currentState} -> ${transition.nextState}');
    super.onTransition(transition);
  }
}
