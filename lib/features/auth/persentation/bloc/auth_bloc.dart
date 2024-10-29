
 import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_source_impl/local_impl/auth_local_data_source_impl.dart';
import '../../domain/use_cases/get_saved_user_use_case.dart';
import '../../domain/use_cases/login_with_email_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/register_with_email_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final RegisterWithEmailUseCase registerWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final GetSavedUserUseCase getSavedUserUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSourceImpl authLocalDataSource; // Add local data source

  AuthBloc({
    required this.loginWithEmailUseCase,
    required this.registerWithEmailUseCase,
    required this.loginWithGoogleUseCase,
    required this.getSavedUserUseCase,
    required this.logoutUseCase,
    required this.authLocalDataSource, // Initialize local data source

  }) : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<GetSavedUserEvent>(_onGetSavedUser);
    on<LogoutEvent>(_onLogout);
    on<SaveUserEvent>(_onSaveUser); // Handle save user event

  }

  Future<void> _onLoginWithEmail(LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginWithEmailUseCase(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterWithEmail(RegisterWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await registerWithEmailUseCase(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(Unauthenticated()); // Registration successful, but not logged in
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginWithGoogleUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetSavedUser(GetSavedUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await getSavedUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSaveUser(SaveUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authLocalDataSource.saveUser(event.user, event.rememberMe); // Save user details
      emit(Authenticated(event.user)); // Emit authenticated state
    } catch (e) {
      emit(AuthError('Saving user failed: ${e.toString()}'));
    }
  }
}