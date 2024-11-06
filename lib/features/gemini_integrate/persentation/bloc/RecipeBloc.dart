import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/FetchRecipesUseCase.dart';
import 'RecipeEvent.dart';
import 'RecipeState.dart';
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final FetchRecipesUseCase fetchRecipesUseCase;

  RecipeBloc({required this.fetchRecipesUseCase}) : super(RecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await fetchRecipesUseCase.execute(event.query);
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(RecipeError("Failed to load recipes"));
      }
    });
  }
}