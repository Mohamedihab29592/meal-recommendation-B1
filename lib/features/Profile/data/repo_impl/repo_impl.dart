import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> updateUserProfile(User user) async {
    await firestore.collection('users').doc(user.id).update((user as UserModel).toFirestore());
  }
}
