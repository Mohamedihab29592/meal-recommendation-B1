import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_recommendation_b1/core/utiles/app_strings.dart';
import 'package:meal_recommendation_b1/core/utiles/secure_storage_helper.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/entity/user_entity.dart';

import '../../../../../../core/common/data_source/remote/auth_remote_data_source.dart';

class RegisterRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  RegisterRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Map<String, dynamic>?> loginWithEmailAndPassword(
      String email, String password) async {
    throw Exception("Not Used Here");
  }

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    SecureStorageHelper.setSecuredString(
        AppStrings.uid, userCredential.user?.uid ?? '');
    await userCredential.user?.updateDisplayName(name);
    // Add phone if needed
  }

  @override
  Future<Map<String, dynamic>?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return _getUserData(userCredential.user);
  }

  @override
  Future<void> logout() async {
    throw Exception("Not Used Here");
  }

  Map<String, dynamic>? _getUserData(User? user) {
    if (user != null) {
      return {
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'phone': user.phoneNumber,
        'profilePhoto': user.photoURL,
      };
    }
    return null;
  }

  @override
  Future<UserEntity?> getSavedUser() {
    throw Exception("Not Used Here");
  }
}
