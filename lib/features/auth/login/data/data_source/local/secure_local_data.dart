import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageLoginHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Load saved email and password
  static Future<Map<String, String>> loadUserData() async {
    final rememberMeValue = await _secureStorage.read(key: 'remember_me');
    final email = await _secureStorage.read(key: 'email') ?? '';
    final password = await _secureStorage.read(key: 'password') ?? '';
    final rememberMe = rememberMeValue == 'true';

    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe.toString(),
    };
  }

  // Save or delete user data based on rememberMe status
  static Future<void> saveUserData({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    if (rememberMe) {
      await _secureStorage.write(key: 'remember_me', value: 'true');
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
    } else {
      await _secureStorage.write(key: 'remember_me', value: 'false');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    }
  }
}
