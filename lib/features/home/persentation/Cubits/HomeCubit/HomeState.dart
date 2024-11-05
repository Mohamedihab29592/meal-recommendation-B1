abstract class HomeState{}
class InintialState extends HomeState{}
class IsLoadingHome extends HomeState{}
class SuccessState extends HomeState{}
class FailureState extends HomeState{
  String? errorMessage;

  FailureState({required this.errorMessage});
}