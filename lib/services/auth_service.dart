import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> initialize() async {
    // Initialize authentication service
    print('AuthService initialized');
  }
  
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }
  
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }
  
  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
  
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
}