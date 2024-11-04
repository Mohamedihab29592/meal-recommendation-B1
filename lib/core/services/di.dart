import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/NavBarCubits/NavBarCubit.dart';
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import '../../features/auth/login/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/login/domain/repository/auth_repository.dart';
import '../../features/auth/login/domain/use_cases/login_with_email_use_case.dart';
import '../../features/auth/login/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/login/domain/use_cases/logout_use_case.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_firebase_data_source_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_remote_data_source_Impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/repository_impl/register_repository_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/repository/register_repository.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/login_with_google_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/register_with_email_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/save_user_data_in_firebase_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:hive/hive.dart';
import '../../features/auth/OTP/data/repository/repository.dart';
import '../../features/auth/OTP/domin/use_case/phone_authentication_use_case.dart';
import '../../features/auth/OTP/domin/use_case/submit_otp_use_case.dart';
import '../../features/auth/OTP/presentation/phone_bloc/phone_bloc.dart';
import '../../features/auth/login/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/login/domain/repository/auth_repository.dart';
import '../../features/auth/login/domain/use_cases/login_with_email_use_case.dart';
import '../../features/auth/login/domain/use_cases/login_with_google_use_case.dart';
import '../../features/auth/login/domain/use_cases/logout_use_case.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/home/favorites/data/models/favorites.dart';
import '../../features/home/favorites/data/repository_impl/favorites_repository_impl.dart';
import '../../features/home/favorites/domain/repository/favorites_repository.dart';
import '../../features/home/favorites/domain/usecases/delete_favorite_use_case.dart';
import '../../features/home/favorites/domain/usecases/get_all_favorites_use_case.dart';
import '../../features/home/favorites/domain/usecases/save_favorite_use_case.dart';
import '../../features/home/favorites/presentaion/bloc/favorites_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup(Box<Favorites> favoriteBox) async {
  // Core dependencies
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());

  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Data Sources

  getIt.registerLazySingleton(() => secureFlutter);
// Data Sources

  getIt.registerLazySingleton<RegisterRemoteDataSourceImpl>(
        () => RegisterRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<RegisterFirebaseDataSourceImpl>(
        () => RegisterFirebaseDataSourceImpl(),
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

  //  HomeCubit
  getIt.registerFactory(() => HomeCubit());
  //  HomeCubit
  getIt.registerFactory(() => NavBarCubit());
        loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
        registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
        loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
        getSavedUserUseCase: getIt<GetSavedUserUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
      ));

  //OTP features

  getIt.registerLazySingleton<OTPRepository>(() => OTPRepository(getIt()));

  getIt
      .registerLazySingleton<BaseOTPRemoteDataSource>(() => RemoteDataSource());

  getIt.registerLazySingleton<PhoneAuthenticationUseCase>(
      () => PhoneAuthenticationUseCase(getIt()));

  getIt
      .registerLazySingleton<SubmitOTPUseCase>(() => SubmitOTPUseCase(getIt()));

  getIt.registerFactory(() => PhoneAuthBloc(
    phoneAuthenticationUseCase: getIt<PhoneAuthenticationUseCase>(),
    submitOTPUseCase: getIt<SubmitOTPUseCase>(),
  ));
}