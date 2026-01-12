import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/generated/auth.pb.dart';

class AuthStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(LoginResponse res) async {
    await _storage.write(key: 'userId', value: res.userId);
    await _storage.write(key: 'email', value: res.email);
    await _storage.write(key: 'name', value: res.name);
  }

  Future<String?> get userId =>
      _storage.read(key: 'userId');

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
