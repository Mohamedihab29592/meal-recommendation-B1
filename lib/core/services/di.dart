import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../../features/Profile/Presentation/bloc/bloc.dart';
import '../../features/Profile/data/Model/UserModel.dart';
import '../../features/Profile/data/dataSource/local/LocalData.dart';
import '../../features/Profile/data/repo_impl/repo_impl.dart';
import '../../features/Profile/domain/repo/repo.dart';
import '../../features/Profile/domain/usecase/editUser.dart';
import '../../features/Profile/domain/usecase/getUser.dart';
import '../../features/Profile/domain/usecase/update_user_image_use_case.dart';
import '../../features/auth/OTP/data/data_source/base_remote_data_source.dart';
import '../../features/auth/OTP/data/data_source/remote_data_source.dart';
import '../../features/auth/OTP/data/repository/repository.dart';
import '../../features/auth/OTP/domin/use_case/phone_authentication_use_case.dart';
import '../../features/auth/OTP/domin/use_case/submit_otp_use_case.dart';
import '../../features/auth/OTP/presentation/phone_bloc/phone_bloc.dart';
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import '../../features/auth/login/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/login/domain/repository/auth_repository.dart';
import '../../features/auth/login/domain/use_cases/login_with_email_use_case.dart';
import '../../features/auth/login/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/login/domain/use_cases/logout_use_case.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/auth/register/data/data_source_impl/remote_impl/register_firebase_data_source_impl.dart';
import '../../features/auth/register/data/data_source_impl/remote_impl/register_remote_data_source_Impl.dart';
import '../../features/auth/register/data/repository_impl/register_repository_impl.dart';
import '../../features/auth/register/domain/repository/register_repository.dart';
import '../../features/auth/register/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/register/domain/use_cases/register_with_email_use_case.dart';
import '../../features/auth/register/domain/use_cases/save_user_data_in_firebase_use_case.dart';
import '../../features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_firebase_data_source_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_remote_data_source_Impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/repository_impl/register_repository_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/repository/register_repository.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/login_with_google_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/register_with_email_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/save_user_data_in_firebase_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import '../../features/auth/OTP/data/repository/repository.dart';
import '../../features/auth/OTP/domin/use_case/phone_authentication_use_case.dart';
import '../../features/auth/OTP/domin/use_case/submit_otp_use_case.dart';
import '../../features/auth/OTP/presentation/phone_bloc/phone_bloc.dart';
import '../../features/favorites/data/models/favorites.dart';
import '../../features/favorites/data/repository_impl/favorites_repository_impl.dart';
import '../../features/favorites/domain/repository/favorites_repository.dart';
import '../../features/favorites/domain/usecases/delete_favorite_use_case.dart';
import '../../features/favorites/domain/usecases/get_all_favorites_use_case.dart';
import '../../features/favorites/domain/usecases/save_favorite_use_case.dart';
import '../../features/favorites/presentaion/bloc/favorites_bloc.dart';
import '../../features/gemini_integrate/data/RecipeRepository.dart';
import '../../features/gemini_integrate/domain/FetchRecipesUseCase.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import '../../features/home/persentation/Cubits/AddRecipesCubit/ImageCubit.dart';
import '../../features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import '../../features/home/persentation/Cubits/NavBarCubits/NavBarCubit.dart';
import 'GeminiApiService.dart';
import 'RecipeApiService.dart';

final getIt = GetIt.instance;

Future<void> setup(Box<Favorites> favoriteBox) async {

  const apiGeminiKey = "AIzaSyAKoyYu10J806FFFA7n2KEO7w3hChyL_Pk";
  const spoonacularApiKey = "4dfcf4986aee47f78776848664336a9c";
  if (!Hive.isAdapterRegistered(32)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  Box<UserModel> userBox = await Hive.openBox<UserModel>('userBox');

  getIt.registerLazySingleton<Box<UserModel>>(() => userBox);
  getIt.registerLazySingleton(()=>FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

    // Data Sources
    getIt.registerLazySingleton<BaseOTPRemoteDataSource>(
        () => RemoteDataSource());
    getIt.registerLazySingleton<RegisterRemoteDataSourceImpl>(
      () => RegisterRemoteDataSourceImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<RegisterFirebaseDataSourceImpl>(
      () => RegisterFirebaseDataSourceImpl(),
    );

    // Registering AuthRemoteDataSource to resolve the missing type
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt(), getIt(), getIt()),
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
    getIt.registerLazySingleton(
        () => RegisterWithEmailUseCase(getIt<RegisterRepository>()));
    getIt.registerLazySingleton(
        () => RegisterWithGoogleUseCase(getIt<RegisterRepository>()));
    getIt.registerLazySingleton(() => SaveUserDataInFirebaseUseCase(getIt()));
    getIt.registerLazySingleton(
        () => LoginWithEmailUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
        () => LoginWithGoogleUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => SaveFavoriteUseCase(getIt()));
    getIt.registerLazySingleton(() => DeleteFavoriteUseCase(getIt()));
    getIt.registerLazySingleton(() => GetAllFavoritesUseCase(getIt()));
    getIt.registerLazySingleton(() => PhoneAuthenticationUseCase(getIt()));
    getIt.registerLazySingleton(() => SubmitOTPUseCase(getIt()));

    getIt.registerLazySingleton<HiveLocalUserDataSource>(
        () => HiveLocalUserDataSource(getIt()));
    getIt.registerLazySingleton<UserRepository>(
      () => FirebaseUserRepository(getIt(), getIt()),
    );
    getIt.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(
        getIt(),
      ),
    );
    getIt.registerLazySingleton(
      () => UploadUserProfileImage(
        userRepository: getIt(),
      ),
    );
    getIt.registerFactory(
      () => UserProfileBloc(
        getIt(),
        getUserProfile: getIt(),
        updateUserProfile: getIt(),
      ),
    );

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

