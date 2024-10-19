// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketplace/presentation/service_locator.dart';
import "package:dartz/dartz.dart";

abstract class SecureStorageDataSource {
  Future<Either> write(String key, String value);
  Future<Either> read(String key);
  Future<Either> delete(String key);
}

class SecureServiceImpl extends SecureStorageDataSource {
  @override
  Future<Either> write(String key, String value) async {
    try {
      await sl<SecureStorage>()._secureStorage.write(key: key, value: value);
      return const Right(null);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> read(String key) async {
    try {
      final String? response =
          await sl<SecureStorage>()._secureStorage.read(key: key);

      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> delete(String key) async {
    try {
      await sl<SecureStorage>()._secureStorage.delete(key: key);
      return const Right(null);
    } catch (e) {
      return Left(e);
    }
  }
}

class SecureStorage {
  late final FlutterSecureStorage _secureStorage;

  SecureStorage() : _secureStorage = const FlutterSecureStorage();
}
