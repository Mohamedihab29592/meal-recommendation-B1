import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/login_with_email_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
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

  Future<void> _onLoginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
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


  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

}
