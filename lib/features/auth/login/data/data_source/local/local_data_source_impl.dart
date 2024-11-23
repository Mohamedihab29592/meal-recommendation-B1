import 'package:hive/hive.dart';

import '../../../../../Profile/data/Model/UserModel.dart';
import '../../../domain/entity/user_entity.dart';

abstract class LocalDataSource {
  Future<bool> checkUserExists(String uid);
  Future<int> getLoginCount(String uid);
  Future<void> incrementLoginCount(String uid);
  Future<void> saveUserIfNotExists(UserEntity user);
  Future<void> clearLoginStatus();
  Future<UserEntity?> getUserData(String uid);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box<dynamic> _box;

  LocalDataSourceImpl(this._box);

  @override
  Future<bool> checkUserExists(String uid) async {
    return _box.containsKey('user_$uid');
  }

  @override
  Future<int> getLoginCount(String uid) async {
    return _box.get('login_count_$uid', defaultValue: 0);
  }

  @override
  Future<void> incrementLoginCount(String uid) async {
    int currentCount = await getLoginCount(uid);
    await _box.put('login_count_$uid', currentCount + 1);
  }

  @override
  Future<void> saveUserIfNotExists(UserEntity user) async {
    if (!await checkUserExists(user.id)) {
    await _box.put('user_${user.id}', user);
    print('User  saved: $user');
    }
  }

  @override
  Future<UserEntity?> getUserData(String uid) async {
    if (await checkUserExists(uid)) {
    final userData = _box.get('user_$uid');
    print('User  retrieved: $userData');
    return userData; // This should be a UserModel instance
    }
    return null;
  }

  @override
  Future<void> clearLoginStatus() async {
    var loginCountKeys = _box.keys.where((key) => key.toString().startsWith('login_count_'));
    await _box.deleteAll(loginCountKeys);
  }

}