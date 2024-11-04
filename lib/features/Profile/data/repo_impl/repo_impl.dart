import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_handler.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repo/repo.dart';
import '../Model/UserModel.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore firestore;

  FirebaseUserRepository(this.firestore);

  @override
  Future<User> getUserProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc.data()!, doc.id);
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await firestore
        .collection('users')
        .doc(user.id)
        .update((user).toFirestore());
    await getUserProfile(user.id);
  }

  @override
  Future<Either<FirebaseErrorModel, String>> uploadUserImage(
      {required File newImage, String? oldImage}) async {
    return await _uploadImageToFirebaseStorage(
        image: newImage, oldImage: oldImage);
  }

  Future<Either<FirebaseErrorModel, String>> _uploadImageToFirebaseStorage(
      {required File image, String? oldImage}) async {
    try {
      String filePath = 'profile_images/${DateTime.now()}.png';
      final imageUrl =
          await FirebaseStorage.instance.ref(filePath).putFile(image);
      String downlownUrl = await imageUrl.ref.getDownloadURL();
      if (oldImage!.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(oldImage);
        await ref.delete();
      }
      return Right(downlownUrl);
    } on FirebaseException catch (e) {
      // Firebase-specific errors
      return Left(
        FirebaseErrorHandler.handle(e),
      );
    } on SocketException {
      // Network error
      return Left(
        FirebaseErrorModel(
            message: 'Network error: No Internet connection.', errorCode: -1),
      );
    } on TimeoutException {
      // Handle timeout
      return Left(
        FirebaseErrorModel(message: 'Upload timed out.', errorCode: -1),
      );
    } on FormatException {
      // Handle format errors
      return Left(
        FirebaseErrorModel(
            message: 'File format error: Image file format is not supported.',
            errorCode: -1),
      );
    } catch (e) {
      // Generic error handling
      return Left(
        FirebaseErrorModel(
            message: 'An unexpected error occurred: $e', errorCode: -1),
      );
    }
  }
}
