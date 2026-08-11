import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/core/utiles/app_strings.dart';
import 'package:meal_recommendation_b1/core/utiles/secure_storage_helper.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/entity/user_entity.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/login_with_google_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/register_with_email_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/use_cases/save_user_data_in_firebase_use_case.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterWithEmailUseCase registerWithEmailUseCase;
  final RegisterWithGoogleUseCase registerWithGoogleUseCase;
  final SaveUserDataInFirebaseUseCase saveUserUseCase;
  RegisterBloc({
    required this.saveUserUseCase,
    required this.registerWithEmailUseCase,
    required this.registerWithGoogleUseCase,
  }) : super(RegisterInitialState()) {
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
  }

  Future<void> _onRegisterWithEmail(
      RegisterWithEmailEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      await registerWithEmailUseCase(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      final userInfo = UserEntity(
          uid: await SecureStorageHelper.getSecuredString(AppStrings.uid),
          name: event.name,
          email: event.email,
          phone: event.phone);
      await _saveUser(
        user: userInfo,
        emit: emit,
        onSuccessState: RegisterUnauthenticatedState(),
      ); // Registration successful, but not logged in
    } catch (e) {
      emit(
        RegisterErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogleEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      final user = await registerWithGoogleUseCase();
      if (user != null) {
        await _saveUser(
            user: user,
            emit: emit,
            onSuccessState: RegisterAuthenticatedState(user));
      } else {
        emit(RegisterUnauthenticatedState());
      }
    } catch (e) {
      emit(
        RegisterErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _saveUser(
      {required UserEntity user,
      required Emitter<RegisterState> emit,
      required RegisterState onSuccessState}) async {
    try {
      Either<FirebaseErrorModel, Unit> userInfo =
          await saveUserUseCase(user: user);
      return userInfo.fold((fail) {
        emit(RegisterErrorState(fail.message ?? "Error Occured"));
      }, (succss) {
        emit(onSuccessState);
      });
    } catch (e) {
      emit(
        RegisterErrorState(
          e.toString(),
        ),
      );
    }
  }
}
