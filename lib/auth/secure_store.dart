import 'package:flutter_auth_provider/flutter_auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_simple_graphql_auth/auth/user.dart';

const String userNameKey = "app_user_user_name";
const String nameKey = "app_user_name";
const String tokenKey = "app_token";
const String refreshTokenKey = "app_refresh_token";

class SecureStore implements AuthStore<User>, TokenStore {
  static const SecureStore _instance = SecureStore._();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const SecureStore._();

  factory SecureStore() => _instance;

  @override
  Future<void> delete() async {
    await _storage.delete(key: userNameKey);
    await _storage.delete(key: nameKey);
  }

  @override
  Future<User?> retrieve() async {
    final userName = await _storage.read(key: userNameKey);
    final name = await _storage.read(key: nameKey);
    if (userName != null && name != null) {
      return User(userName: userName, name: name);
    }
    return null;
  }

  @override
  Future<void> save(User user) async {
    await _storage.write(key: userNameKey, value: user.userName);
    await _storage.write(key: nameKey, value: user.name);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: refreshTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  @override
  Future<String?> getToken() async {
    return _storage.read(key: tokenKey);
  }

  @override
  Future<void> saveTokens({required String token, String? refreshToken}) async {
    await _storage.write(key: tokenKey, value: token);
    if (refreshToken != null) {
      await _storage.write(key: refreshTokenKey, value: refreshToken);
    }
  }
}
