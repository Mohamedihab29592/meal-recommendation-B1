 import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthRemoteDataSource{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);

  Future<Map<String, dynamic>?> loginWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _getUserData(userCredential.user);
  }



  Future<Map<String, dynamic>?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _getUserData(userCredential.user);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
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