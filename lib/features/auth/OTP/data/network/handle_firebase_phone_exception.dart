import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/failure/failure.dart';

Failure handleFirebasePhoneException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-phone-number':
      return AuthFailure(message: 'Invalid phone number');
    case 'too-many-requests':
      return AuthFailure(message: 'Too many requests. Please try again later.');
    case 'quota-exceeded':
      return AuthFailure(message: 'SMS quota exceeded');
    case 'network-request-failed':
      return AuthFailure(message: 'Network error. Check your connection');
    case 'app-not-authorized':
      return AuthFailure(
          message: 'App is not authorized to use Firebase Authentication');
    default:
      return ServerFailure(message: e.code);
  }
}
