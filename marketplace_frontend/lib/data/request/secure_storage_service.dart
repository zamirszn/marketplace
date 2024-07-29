import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeSecureData({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData({required String key}) async {
    await _storage.delete(key: key);
  }

  // TODO: add to logout

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}

final SecureStorageService secureStorageService = SecureStorageService();
