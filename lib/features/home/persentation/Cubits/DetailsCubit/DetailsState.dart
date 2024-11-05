abstract class DetailsState{}
class InitialState extends DetailsState{}
class IsLoadingDetailsState extends DetailsState{}
class SucessState extends DetailsState{}
class FailureState extends DetailsState{
  String? errorMessage;

  FailureState({this.errorMessage});
}