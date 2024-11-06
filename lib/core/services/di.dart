import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import '../../features/auth/login/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/login/domain/repository/auth_repository.dart';
import '../../features/auth/login/domain/use_cases/login_with_email_use_case.dart';
import '../../features/auth/login/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/login/domain/use_cases/logout_use_case.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup(Box<Favorites> favoriteBox) async {
  // Core dependencies
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
Future<void> setup() async {
  const apiGeminiKey = "AIzaSyAKoyYu10J806FFFA7n2KEO7w3hChyL_Pk";
  const spoonacularApiKey = "4dfcf4986aee47f78776848664336a9c";

  const secureFlutter =  FlutterSecureStorage();
  getIt.registerLazySingleton(()=>FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Data Sources
  getIt.registerLazySingleton<BaseOTPRemoteDataSource>(() => RemoteDataSource());
  getIt.registerLazySingleton<RegisterRemoteDataSourceImpl>(
        () => RegisterRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<RegisterFirebaseDataSourceImpl>(
        () => RegisterFirebaseDataSourceImpl(),
  );

  // Registering AuthRemoteDataSource to resolve the missing type
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(getIt(),getIt(),getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<RegisterRepository>(
        () => RegisterRepositoryImpl(
      getIt<RegisterRemoteDataSourceImpl>(),
      getIt<RegisterFirebaseDataSourceImpl>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
        () => FavoritesRepositoryImpl(favoriteBox),
  );
  getIt.registerLazySingleton<OTPRepository>(
        () => OTPRepository(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => RegisterWithEmailUseCase(getIt<RegisterRepository>()));
  getIt.registerLazySingleton(() => RegisterWithGoogleUseCase(getIt<RegisterRepository>()));
  getIt.registerLazySingleton(() => SaveUserDataInFirebaseUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SaveFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllFavoritesUseCase(getIt()));
  getIt.registerLazySingleton(() => PhoneAuthenticationUseCase(getIt()));
  getIt.registerLazySingleton(() => SubmitOTPUseCase(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
    loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
    loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
  ));

  getIt.registerFactory(() => RegisterBloc(
    registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
    registerWithGoogleUseCase: getIt<RegisterWithGoogleUseCase>(),
    saveUserUseCase: getIt<SaveUserDataInFirebaseUseCase>(),
  ));

  getIt.registerFactory(() => FavoritesBloc(
    getIt<SaveFavoriteUseCase>(),
    getIt<DeleteFavoriteUseCase>(),
    getIt<GetAllFavoritesUseCase>(),
  ));

  getIt.registerFactory(() => PhoneAuthBloc(
    phoneAuthenticationUseCase: getIt<PhoneAuthenticationUseCase>(),
    submitOTPUseCase: getIt<SubmitOTPUseCase>(),
  ));
  //  HomeCubit
   getIt.registerFactory(() => HomeCubit());
  //  NavBar
  getIt.registerFactory(() => NavBarCubit());
  //  Add Ingrediants
  getIt.registerFactory(() => ImageCubit());
  //detals
   getIt.registerFactory(() => DetailsCubit());


  // Register services
  getIt.registerLazySingleton<RecipeApiService>(() => RecipeApiService(apiKey: spoonacularApiKey));
  getIt.registerLazySingleton<GeminiApiService>(() => GeminiApiService(apiKey: apiGeminiKey));

  // Register repositories
  getIt.registerLazySingleton<RecipeRepository>(() => RecipeRepository(
    apiService: getIt<RecipeApiService>(),
    geminiApiService: getIt<GeminiApiService>(),
  ));

  // Register use cases
  getIt.registerLazySingleton<FetchRecipesUseCase>(() => FetchRecipesUseCase(repository: getIt<RecipeRepository>()));

  // Register BLoC
  getIt.registerFactory<RecipeBloc>(() => RecipeBloc(fetchRecipesUseCase: getIt<FetchRecipesUseCase>()));
}

}