import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/utiles/secure_storage_helper.dart';
import 'package:meal_recommendation_b1/features/Profile/data/Model/UserModel.dart';

import '../repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
    await _deleteUserFromFirebase();
  }

  Future<void> _deleteUserFromFirebase() async {
    await getIt<FirebaseFirestore>()
        .collection('users')
        .doc(
          SecureStorageHelper.getSecuredString('uid'),
        )
        .delete();
  }
  Future<void> _deleteUserFromHive() async {

    //await Hive.box<UserModel>('userBox').delete();
  }
    
    
    }
