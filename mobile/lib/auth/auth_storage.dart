import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/generated/auth.pb.dart';

class AuthStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(LoginResponse res, {String? photoUrl}) async {
    await _storage.write(key: 'userId', value: res.userId);
    await _storage.write(key: 'email', value: res.email);
    await _storage.write(key: 'name', value: res.name);
    if (photoUrl != null) {
      await _storage.write(key: 'photoUrl', value: photoUrl);
    }
  }

  Future<String?> get userId =>
      _storage.read(key: 'userId');

  Future<String?> get name =>
      _storage.read(key: 'name');

  Future<String?> get email =>
      _storage.read(key: 'email');

  Future<String?> get photoUrl =>
      _storage.read(key: 'photoUrl');

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
