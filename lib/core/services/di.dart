import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

final getIt = GetIt.instance;

Future<void> setup() async {
  final secureFlutter = await FlutterSecureStorage();

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => secureFlutter);
// Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSourceImpl>(
          () => AuthRemoteDataSourceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<AuthLocalDataSourceImpl>(
          () => AuthLocalDataSourceImpl(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt(), getIt()));

  // Use Cases
  getIt.registerLazySingleton(
          () => LoginWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
          () => RegisterWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
          () => LoginWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
          () => GetSavedUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));

  // Bloc
  getIt.registerFactory(() => AuthBloc(
    loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
    registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
    loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
    getSavedUserUseCase: getIt<GetSavedUserUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    authLocalDataSource: getIt<AuthLocalDataSourceImpl>(),
  ));
}
