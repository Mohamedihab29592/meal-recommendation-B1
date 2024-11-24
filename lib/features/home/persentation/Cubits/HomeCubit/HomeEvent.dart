import 'package:flutter/material.dart';

abstract class HomeEvent {}

class FetchRecipesEvent extends HomeEvent {}

class FilterRecipesEvent extends HomeEvent {
  final String? mealType;
  final int? cookingTime;
  final RangeValues? caloriesRange;
  final RangeValues? proteinRange;
  final RangeValues? carbsRange;
  final RangeValues? fatRange;
  final List<String>? selectedVitamins;
  final int? maxIngredients;

  FilterRecipesEvent({
    this.mealType,
    this.cookingTime,
    this.caloriesRange,
    this.proteinRange,
    this.carbsRange,
    this.fatRange,
    this.selectedVitamins,
    this.maxIngredients,
  });
}

class SearchRecipesEvent extends HomeEvent {
  final String query;
  SearchRecipesEvent(this.query);
}

class SortRecipesEvent extends HomeEvent {
  final String sortBy;
  final bool ascending;

  SortRecipesEvent({required this.sortBy, this.ascending = true});
}

class ResetFiltersEvent extends HomeEvent {}

class ToggleFavoriteEvent extends HomeEvent {
  final String recipeId;
  ToggleFavoriteEvent(this.recipeId);
}

class DeleteRecipeEvent extends HomeEvent {
  final String recipeId;
  DeleteRecipeEvent(this.recipeId);
}