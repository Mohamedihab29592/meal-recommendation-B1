import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberEntities {
  final String phoneNumber;
  final Function(PhoneAuthCredential) verificationCompleted;
  final Function(FirebaseAuthException) verificationFailed;
  final Function(String, int?) codeSent;
  final Function(String) codeAutoRetrievalTimeout;

  const PhoneNumberEntities(
      {required this.phoneNumber,
      required this.verificationCompleted,
      required this.verificationFailed,
      required this.codeSent,
      required this.codeAutoRetrievalTimeout});
}
