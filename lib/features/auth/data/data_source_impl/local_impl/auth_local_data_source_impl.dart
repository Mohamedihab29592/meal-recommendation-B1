import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/entity/user_entity.dart';

class AuthLocalDataSourceImpl {
  final FlutterSecureStorage flutterSecureStorage;

  AuthLocalDataSourceImpl(this.flutterSecureStorage);

  Future<void> saveUser(UserEntity user, bool rememberMe) async {
    await flutterSecureStorage.write(key: 'uid', value: user.uid);
    await flutterSecureStorage.write(key: 'name', value: user.name);
    await flutterSecureStorage.write(key: 'email', value: user.email);
    await flutterSecureStorage.write(key: 'phone', value: user.phone);
  }


  Future<UserEntity?> getUser() async {
    final uid = await flutterSecureStorage.read(key: 'uid');
    final name = await flutterSecureStorage.read(key: 'name');
    final email = await flutterSecureStorage.read(key: 'email');
    final phone = await flutterSecureStorage.read(key: 'phone');
    if (uid != null && name != null && email != null && phone != null) {
      return UserEntity(uid: uid, name: name, email: email, phone: phone);
    }
    return null;
  }

  Future<void> clearUser() async {
    await flutterSecureStorage.delete(key: 'uid');
    await flutterSecureStorage.delete(key: 'name');
    await flutterSecureStorage.delete(key: 'email');
    await flutterSecureStorage.delete(key: 'phone');
  }
}
