import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import '../../../login/domain/entity/user_entity.dart';
import '../../domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  RegisterRepositoryImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate inputs
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      // Register user with Firebase Authentication
      final UserCredential userCredential =
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Create user entity
      final UserEntity newUser = UserEntity(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        profilePhoto: '',
      );

      await addNewUser(user: newUser);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      switch (e.code) {
        case 'weak-password':
          throw Exception('The password is too weak');
        case 'email-already-in-use':
          throw Exception('An account already exists with this email');
        case 'invalid-email':
          throw Exception('Invalid email address');
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    try {
      // Perform Google Sign-In
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      // Get Google authentication credentials
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) return null;

      // Create UserEntity from Google Sign-In
      return UserEntity(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber ?? '',
        profilePhoto: firebaseUser.photoURL ?? '',
      );
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  @override
  Future<Either<FirebaseErrorModel, Unit>> addNewUser({
    required UserEntity user
  }) async {
    try {

      if (user.id.isEmpty) {
        return Left(FirebaseErrorModel(
          errorCode: 1,
          message: 'User ID is required',
        ));
      }

      final userRef = firestore.collection('users').doc(user.id);

      final userData = user.toJson();

      await userRef.set(userData);

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorModel(
        errorCode: int.tryParse(e.code),
        message: e.message ?? 'Unknown Firestore error',
      ));
    } catch (e) {

      return Left(FirebaseErrorModel(
        errorCode: 2,
        message: e.toString(),
      ));
    }
  }
}



extension UserEntityExtension on UserEntity {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': profilePhoto,
      'profilePhoto': profilePhoto,
    };
  }
}
