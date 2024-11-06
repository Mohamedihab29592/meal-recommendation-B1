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
import '../dataSource/local/LocalData.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore firestore;
  final HiveLocalUserDataSource localDataSource;

  FirebaseUserRepository(this.firestore, this.localDataSource);

  @override
  Future<User> getUserProfile(String userId) async {
    // Check local storage first
    final localUser = localDataSource.getUser(userId);
    if (localUser != null) {
      return localUser;
    }

    // If not in local storage, fetch from Firebase
    final doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      final user = UserModel.fromFirestore(doc.data()!, doc.id);

      // Save to local storage for future access
      await localDataSource.saveUser(user);
      return user;
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

    // Update the local storage
    await localDataSource.saveUser(user);
  }

  @override
  Future<Either<FirebaseErrorModel, String>> uploadUserImage({
    required File newImage,
    String? oldImage,
  }) async {
    return await _uploadImageToFirebaseStorage(
      image: newImage,
      oldImage: oldImage,
    );
  }

  Future<Either<FirebaseErrorModel, String>> _uploadImageToFirebaseStorage({
    required File image,
    String? oldImage,
  }) async {
    try {
      String filePath = 'profile_images/${DateTime.now()}.png';
      final imageUrl =
          await FirebaseStorage.instance.ref(filePath).putFile(image);
      String downloadUrl = await imageUrl.ref.getDownloadURL();
      if (oldImage != '') {
        final ref = FirebaseStorage.instance.refFromURL(oldImage!);
        await ref.delete();
      }
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.handle(e));
    } on SocketException {
      return Left(
        FirebaseErrorModel(
            message: 'Network error: No Internet connection.', errorCode: -1),
      );
    } on TimeoutException {
      return Left(
        FirebaseErrorModel(message: 'Upload timed out.', errorCode: -1),
      );
    } on FormatException {
      return Left(
        FirebaseErrorModel(
          message: 'File format error: Image file format is not supported.',
          errorCode: -1,
        ),
      );
    } catch (e) {
      return Left(
        FirebaseErrorModel(
          message: 'An unexpected error occurred: $e',
          errorCode: -1,
        ),
      );
    }
  }
}
