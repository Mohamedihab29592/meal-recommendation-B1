abstract class DetailsState {}

class InitialState extends DetailsState {}

class LoadingState extends DetailsState {}

class LoadedState extends DetailsState {
  final Map<String, dynamic> recipe;

  LoadedState({required this.recipe});
}

class ErrorState extends DetailsState {
  final String message;

  ErrorState({required this.message});
}