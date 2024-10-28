import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
 import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
  import 'package:shared_preferences/shared_preferences.dart';

 import '../../features/auth/data/data_source/local/AuthLocalDataSource.dart';
import '../../features/auth/data/data_source/remote/auth_remote_data_source.dart';
import '../../features/auth/data/data_source_impl/local_impl/auth_local_data_source_impl.dart';
import '../../features/auth/data/data_source_impl/remote_impl/auth_remote_data_source_Impl.dart';
import '../../features/auth/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/use_cases/get_saved_user_use_case.dart';
import '../../features/auth/domain/use_cases/login_with_email_use_case.dart';
import '../../features/auth/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/register_with_email_use_case.dart';
import '../../features/auth/persentation/bloc/auth_bloc.dart';
import '../../features/home/favorites/data/models/favorites.dart';
import '../../features/home/favorites/data/repository_impl/favorites_repository_impl.dart';
import '../../features/home/favorites/domain/repository/favorites_repository.dart';
import '../../features/home/favorites/domain/usecases/delete_favorite_use_case.dart';
import '../../features/home/favorites/domain/usecases/get_all_favorites_use_case.dart';
import '../../features/home/favorites/domain/usecases/save_favorite_use_case.dart';
import '../../features/home/favorites/presentaion/bloc/favorites_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup(Box<Favorites> favoriteBox) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(getIt(), getIt()));

  getIt.registerLazySingleton<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt(), getIt()));

  getIt.registerLazySingleton<FavoritesRepository>(
          () => FavoritesRepositoryImpl(favoriteBox));

  getIt.registerLazySingleton<SaveFavoriteUseCase>(() => SaveFavoriteUseCase(getIt()));
  getIt.registerLazySingleton<DeleteFavoriteUseCase>(() => DeleteFavoriteUseCase(getIt()));
  getIt.registerLazySingleton<GetAllFavoritesUseCase>(() => GetAllFavoritesUseCase(getIt()));

  getIt.registerFactory(() => FavoritesBloc(getIt(), getIt(), getIt()));

  getIt.registerFactory(() => AuthBloc(
    loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
    registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
    loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
    getSavedUserUseCase: getIt<GetSavedUserUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
  ));

}