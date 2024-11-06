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
import '../../features/gemini_integrate/data/RecipeRepository.dart';
import '../../features/gemini_integrate/domain/FetchRecipesUseCase.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import 'GeminiApiService.dart';
import 'RecipeApiService.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  const apiGeminiKey = "AIzaSyAKoyYu10J806FFFA7n2KEO7w3hChyL_Pk";
  const spoonacularApiKey = "4dfcf4986aee47f78776848664336a9c";

  const secureFlutter =  FlutterSecureStorage();
  getIt.registerLazySingleton(()=>FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => secureFlutter);
// Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSource(getIt(), getIt(),getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt()));

  // Use Cases
  getIt.registerLazySingleton(
          () => LoginWithEmailUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton(
          () => LoginWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));

  // Bloc
  getIt.registerFactory(() => AuthBloc(
    loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
    loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
  ));


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
