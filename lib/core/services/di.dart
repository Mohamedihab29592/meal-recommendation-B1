import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_recommendation_b1/features/Profile/data/repo_impl/repo_impl.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/repo/repo.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/editUser.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/getUser.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/update_user_image_use_case.dart';
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

final getIt = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt(), getIt()));

  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
      getIt(),
    ),
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
    () => AuthBloc(
      loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
      registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
      loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
      getSavedUserUseCase: getIt<GetSavedUserUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
}
