import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/domain/entity/phone_number_entities.dart';
import 'package:meal_recommendation_b1/features/auth/domain/use_cases/phone_authentication_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/domain/use_cases/submit_otp_use_case.dart';
import 'package:meal_recommendation_b1/features/auth/persentation/bloc/phone_bloc/phone_event.dart';
import 'package:meal_recommendation_b1/features/auth/persentation/bloc/phone_bloc/phone_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  late String verificationId;

  PhoneAuthBloc() : super(PhoneAuthInitial()) {
    on<SubmittedPhoneNumber>(onPhoneNumberSubmitted);
    on<SignIn>(onSignIn);
  }

  // Handler for Phone Number Submission
  Future<void> onPhoneNumberSubmitted(
      SubmittedPhoneNumber event, Emitter<PhoneAuthState> emit) async {
    emit(Loading());
    final phoneAuthenticationUseCase = getIt<PhoneAuthenticationUseCase>();
    final result = await phoneAuthenticationUseCase.call(PhoneNumberEntities(
      phoneNumber: "+2010208820832",
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      codeSent: _codeSent,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
    ));

    result.fold(
      (failure) {
        emit(ErrorOccurred(errorMsg: failure.message));
      },
      (_) =>
          {}, // Do nothing here since `codeSent` and `verificationCompleted` handle the UI state
    );
  }

  // Handler for OTP SignIn
  Future<void> onSignIn(SignIn event, Emitter<PhoneAuthState> emit) async {
    emit(Loading());
    final submitOTPUseCase = getIt<SubmitOTPUseCase>();
    final result = await submitOTPUseCase.call(event.otpCode, verificationId);

    result.fold(
      (failure) => emit(ErrorOccurred(errorMsg: failure.message)),
      (_) => emit(PhoneOTPVerified()),
    );
  }

  // Callback for verification completed
  void _verificationCompleted(PhoneAuthCredential credential) async {
    await _signIn(credential);
  }

  // Callback for verification failed
  void _verificationFailed(FirebaseAuthException error) {
    emit(ErrorOccurred(errorMsg: error.message ?? 'Verification failed'));
  }

  // Callback for code sent
  void _codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneNumberSubmitted());
  }

  // Callback for code auto-retrieval timeout
  void _codeAutoRetrievalTimeout(String verificationId) {
    this.verificationId =
        verificationId; // Optionally update the verificationId
    print('Code auto-retrieval timed out');
  }

  // Sign in using the phone credential
  Future<void> _signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
    } catch (error) {
      emit(ErrorOccurred(errorMsg: error.toString()));
    }
  }
}

