/*
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entity/user_entity.dart';
import '../../../../../../core/common/data_source/local/AuthLocalDataSource.dart';

class RegisterLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  RegisterLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(UserEntity user) async {
    await sharedPreferences.setString('uid', user.uid);
    await sharedPreferences.setString('name', user.name);
    await sharedPreferences.setString('email', user.email);
    await sharedPreferences.setString('phone', user.phone);
  }

  @override
  Future<UserEntity?> getUser() async {
    final uid = sharedPreferences.getString('uid');
    final name = sharedPreferences.getString('name');
    final email = sharedPreferences.getString('email');
    final phone = sharedPreferences.getString('phone');

    if (uid != null && name != null && email != null && phone != null) {
      return UserEntity(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
      );
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove('uid');
    await sharedPreferences.remove('name');
    await sharedPreferences.remove('email');
    await sharedPreferences.remove('phone');
  }
}
*/
