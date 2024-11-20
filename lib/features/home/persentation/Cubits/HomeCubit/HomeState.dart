import '../../../../gemini_integrate/data/Recipe.dart';

abstract class HomeState{}
class InitialState extends HomeState{}
class IsLoadingHome extends HomeState{}
class SuccessState extends HomeState{
  List<Recipe> data = [];
  SuccessState(this.data);
}
class FailureState extends HomeState{
  String? errorMessage;

  FailureState({required this.errorMessage});
}