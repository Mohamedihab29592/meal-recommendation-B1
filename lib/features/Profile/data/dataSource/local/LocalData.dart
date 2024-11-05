import 'package:hive/hive.dart';

import '../../Model/UserModel.dart';

class HiveLocalUserDataSource {
  final Box<UserModel> userBox;

  HiveLocalUserDataSource(this.userBox);

  Future<void> saveUser(UserModel user) async {
    await userBox.put(user.id, user);
  }

  UserModel? getUser(String userId) {
    return userBox.get(userId);
  }

  Future<void> deleteUser(String userId) async {
    await userBox.delete(userId);
  }
}
