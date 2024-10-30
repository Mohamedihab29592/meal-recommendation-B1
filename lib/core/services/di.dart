import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/local_impl/register_local_data_source_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_firebase_data_source_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/data_source_impl/remote_impl/register_remote_data_source_Impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/data/repository_impl/register_repository_impl.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/repository/register_repository.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/login_with_google_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/register_with_email_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/save_user_data_in_firebase_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton(() => GoogleSignIn());
// Data Sources
  getIt.registerLazySingleton<RegisterRemoteDataSourceImpl>(
      () => RegisterRemoteDataSourceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<RegisterLocalDataSourceImpl>(
      () => RegisterLocalDataSourceImpl(getIt()));
  getIt.registerLazySingleton<RegisterFirebaseDataSourceImpl>(
      () => RegisterFirebaseDataSourceImpl());
  // Repository
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      getIt<RegisterRemoteDataSourceImpl>(),
      getIt<RegisterFirebaseDataSourceImpl>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => RegisterWithEmailUseCase(
      getIt<RegisterRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => LoginWithGoogleUseCase(
      getIt<RegisterRepository>(),
    ),
  );
  getIt.registerLazySingleton<SaveUserDataInFirebaseUseCase>(
    () => SaveUserDataInFirebaseUseCase(
      getIt(),
    ),
  );
  // Bloc
  getIt.registerFactory(() => RegisterBloc(
        registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
        loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
        saveUserUseCase: getIt<SaveUserDataInFirebaseUseCase>(),
      ));
}
