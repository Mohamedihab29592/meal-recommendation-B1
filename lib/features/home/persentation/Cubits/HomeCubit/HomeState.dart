import '../../../../gemini_integrate/data/Recipe.dart';

abstract class HomeState {
  final int stateId;

  HomeState({int? stateId}) : stateId = stateId ?? DateTime.now().millisecondsSinceEpoch;
}

class InitialState extends HomeState {
  InitialState({super.stateId});
}

class HomeLoaded extends HomeState {
  final List<Recipe> homeRecipes;
  final List<Recipe> favoriteRecipes;
  final List<Recipe> filteredRecipes;

  HomeLoaded({
    required this.homeRecipes,
    required this.favoriteRecipes,
     this.filteredRecipes = const [],
    super.stateId
  });

  // Override equality to force rebuilds
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HomeLoaded &&
              runtimeType == other.runtimeType &&
              stateId != other.stateId;

  @override
  int get hashCode => stateId.hashCode;
}

class IsLoadingHome extends HomeState {
  IsLoadingHome({super.stateId});
}

class IsLoadingFavorites extends HomeState {
  IsLoadingFavorites({super.stateId});
}

class FailureState extends HomeState {
  final String errorMessage;

  FailureState({
    required this.errorMessage,
    super.stateId
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FailureState &&
              runtimeType == other.runtimeType &&
              errorMessage == other.errorMessage &&
              stateId != other.stateId;

  @override
  int get hashCode => Object.hash(errorMessage, stateId);
}