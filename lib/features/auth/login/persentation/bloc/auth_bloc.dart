import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/secure_storage_helper.dart';

import '../../../../../core/utiles/app_strings.dart';
import '../../data/data_source/local/local_data_source_impl.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/use_cases/login_with_email_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final LocalDataSource localDataSource;

  AuthBloc(
    this.localDataSource, {
    required this.loginWithEmailUseCase,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoginWithEmail(
      LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final loginResult =
          await loginWithEmailUseCase(event.email, event.password);

      if (loginResult.user != null) {
        emit(Authenticated(
            user: loginResult.user!,
            isNewUser: loginResult.isNewUser,
            isFirstLogin: loginResult.isFirstLogin,
            authMethod: AuthenticationMethod.email));


      } else {
        emit(Unauthenticated(
            errorMessage: 'Login failed',
            lastAttemptedMethod: AuthenticationMethod.email));
      }
    } catch (e) {
      emit(AuthError(
          errorMessage: e.toString(), errorType: AuthErrorType.unknown));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final loginResult = await loginWithGoogleUseCase();

      if (loginResult.user != null) {
        emit(Authenticated(
            user: loginResult.user!,
            isNewUser: loginResult.isNewUser,
            isFirstLogin: loginResult.isFirstLogin,
            authMethod: AuthenticationMethod.email));
      } else {
        emit(Unauthenticated(
            errorMessage: 'Login failed',
            lastAttemptedMethod: AuthenticationMethod.email));
      }
    } catch (e) {
      emit(AuthError(
          errorMessage: e.toString(), errorType: AuthErrorType.unknown));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      await SecureStorageHelper.setSecuredString('uid', '');
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(
          errorMessage: e.toString(), errorType: AuthErrorType.unknown));
    }
  }

}
