import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<Either<Unit, String>> uploadUserImage(
      {required File newImage, String? oldImage}) async {
    return await _uploadImageToFirebaseStorage(
        image: newImage, oldImage: oldImage);
  }

  Future<Either<Unit, String>> _uploadImageToFirebaseStorage(
      {required File image, String? oldImage}) async {
    try {
      String filePath = 'profile_images/${DateTime.now()}.png';
      final imageUrl =
          await FirebaseStorage.instance.ref(filePath).putFile(image);
      String downlownUrl = await imageUrl.ref.getDownloadURL();
      if (oldImage != null) {
        await FirebaseStorage.instance.ref(oldImage).delete();
      }
      return Right(downlownUrl);
    } on FirebaseException catch (e) {
      // Firebase-specific errors
      if (e.code == 'unauthorized') {
        // Handle permission error
        print('User does not have permission to upload to this reference.');
      } else if (e.code == 'canceled') {
        // Handle cancel error
        print('Upload was canceled.');
      } else if (e.code == 'object-not-found') {
        // Handle path not found
        print('File not found at specified path.');
      } else {
        // General Firebase error
        print('FirebaseException: ${e.message}');
      }
      return Left(unit);
    } on SocketException {
      // Network error
      print('Network error: No Internet connection.');
      return Left(unit);
    } on TimeoutException {
      // Handle timeout
      print('Upload timed out.');
      return Left(unit);
    } on FormatException {
      // Handle format errors
      print('File format error: Image file format is not supported.');
      return Left(unit);
    } catch (e) {
      // Generic error handling
      print('An unexpected error occurred: $e');
      return Left(unit);
    }
  }
}
