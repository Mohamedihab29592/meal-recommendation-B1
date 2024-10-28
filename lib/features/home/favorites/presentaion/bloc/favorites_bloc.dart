import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_favorite_use_case.dart';
import '../../domain/usecases/get_all_favorites_use_case.dart';
import '../../domain/usecases/save_favorite_use_case.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SaveFavoriteUseCase saveFavoriteUseCase;
  final DeleteFavoriteUseCase deleteFavoriteUseCase;
  final GetAllFavoritesUseCase getAllFavoritesUseCase;

  FavoritesBloc(
      this.saveFavoriteUseCase,
      this.deleteFavoriteUseCase,
      this.getAllFavoritesUseCase)
      : super(FavoritesInitial()) {
    on<SaveFavoriteEvent>(_onSaveFavorite);
    on<DeleteFavoriteEvent>(_onDeleteFavorite);
    on<GetAllFavoritesEvent>(_onGetAllFavorites);
  }

  Future<void> _onSaveFavorite(
      SaveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      await saveFavoriteUseCase(event.favorite);
      emit(SaveFavoriteDone());
    } catch (e) {
      emit(SaveFavoriteError(e.toString()));
    }
  }

  Future<void> _onDeleteFavorite(
      DeleteFavoriteEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      await deleteFavoriteUseCase(event.id);
      emit(DeleteFavoriteDone());
    } catch (e) {
      emit(DeleteFavoriteError(e.toString()));
    }
  }

  Future<void> _onGetAllFavorites(
      GetAllFavoritesEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favorites = await getAllFavoritesUseCase();
      emit(GetAllFavoritesDone(favorites));
    } catch (e) {
      emit(GetAllFavoritesError(e.toString()));
    }
  }
}
