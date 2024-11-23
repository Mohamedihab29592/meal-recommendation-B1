import '../../../../gemini_integrate/data/Recipe.dart';

abstract class HomeState {}

class InitialState extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Recipe> homeRecipes;
  final List<Recipe> favoriteRecipes;

  HomeLoaded({required this.homeRecipes, required this.favoriteRecipes});
}

class IsLoadingHome extends HomeState {}

class IsLoadingFavorites extends HomeState {}

class FailureState extends HomeState {
  final String errorMessage;
  FailureState({required this.errorMessage});
}