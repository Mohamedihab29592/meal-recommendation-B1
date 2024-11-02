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

final getIt = GetIt.instance;

Future<void> setup() async {
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
  //  HomeCubit
  getIt.registerFactory(() => HomeCubit());
  //  HomeCubit
  getIt.registerFactory(() => NavBarCubit());
}
