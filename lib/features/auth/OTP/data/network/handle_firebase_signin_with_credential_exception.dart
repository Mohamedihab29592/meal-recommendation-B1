import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/failure/failure.dart';

Failure handleSignInwWithCredentialException(FirebaseAuthException e) {
  print(e.code);
  switch (e.code) {
    case 'invalid-verification-code':
      return AuthFailure(message: 'Invalid verification code');
    case 'invalid-verification-id':
      return AuthFailure(message: 'Invalid verification ID');
    case 'credential-already-in-use':
      return AuthFailure(message: 'This credential is already in use');
    case 'user-disabled':
      return AuthFailure(message: 'User account has been disabled');
    case 'operation-not-allowed'||'channel-error':
      return AuthFailure(
          message: 'Operation not allowed. Please contact support');
    default:
      return ServerFailure(message: e.code);
  }
}
