import '../../../../gemini_integrate/data/Recipe.dart';

abstract class HomeState {}

class InitialState extends HomeState {
  InitialState();
}

class HomeLoaded extends HomeState {
  final List<Recipe> homeRecipes;
  final List<Recipe> favoriteRecipes;
  final List<Recipe> filteredRecipes;

  HomeLoaded({
    required this.homeRecipes,
    required this.favoriteRecipes,
     this.filteredRecipes = const [],
  });
}

class IsLoadingHome extends HomeState {
  IsLoadingHome();
}

class IsLoadingFavorites extends HomeState {
  IsLoadingFavorites();
}

class FailureState extends HomeState {
  final String errorMessage;

  FailureState({
    required this.errorMessage,
  });

}