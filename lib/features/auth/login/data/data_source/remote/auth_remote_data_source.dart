 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthRemoteDataSource{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
 final FirebaseFirestore _firestore;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn, this._firestore);

  Future<Map<String, dynamic>?> loginWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _getUserData(userCredential.user);
  }



  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'profilePhoto': user.photoURL,
        }, SetOptions(merge: true));
      }

      return _getUserData(user);
    } catch (e) {
      print("Error logging in with Google: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Map<String, dynamic>? _getUserData(User? user) {
    if (user != null) {
      return {
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'phone': user.phoneNumber,
      };
    }
    return null;
  }
}