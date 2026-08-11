import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/presentation/phone_bloc/phone_event.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/presentation/phone_bloc/phone_state.dart';

import '../../domin/entites/phone_number_entities.dart';
import '../../domin/use_case/phone_authentication_use_case.dart';
import '../../domin/use_case/submit_otp_use_case.dart';


class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  String verificationId='';
  final PhoneAuthenticationUseCase phoneAuthenticationUseCase;
  final SubmitOTPUseCase submitOTPUseCase ;

  PhoneAuthBloc({required this.phoneAuthenticationUseCase,required this.submitOTPUseCase}) : super(PhoneAuthInitial()) {
    on<SubmittedPhoneNumber>(onPhoneNumberSubmitted);
    on<SignIn>(onSignIn);
  }

  Future<void> onPhoneNumberSubmitted(
      SubmittedPhoneNumber event, Emitter<PhoneAuthState> emit) async {
    emit(Loading());
    final result = await phoneAuthenticationUseCase.call(PhoneNumberEntities(
      phoneNumber: "+2${event.phoneNumber}",
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
          {
            emit(PhoneNumberSubmitted()),
          },
    );
  }

  // Handler for OTP SignIn
  Future<void> onSignIn(SignIn event, Emitter<PhoneAuthState> emit) async {
    emit(Loading());
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

