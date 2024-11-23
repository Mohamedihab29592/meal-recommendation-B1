import '../../../../auth/login/domain/entity/user_entity.dart';
import '../../../../gemini_integrate/data/Recipe.dart';

abstract class HomeState{}
class InitialState extends HomeState{}
class IsLoadingHome extends HomeState{}
class SuccessState extends HomeState{
  List<Recipe> data = [];
  SuccessState(this.data);
}
class GetSuccessState extends HomeState{
  UserEntity user;
  GetSuccessState(this.user);
}
class FailureState extends HomeState{
  String? errorMessage;

  FailureState({required this.errorMessage});
}