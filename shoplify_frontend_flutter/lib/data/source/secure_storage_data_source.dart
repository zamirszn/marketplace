// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:dartz/dartz.dart";

abstract class SecureStorageDataSource {
  Future<Either> write(String key, String value);
  Future<Either> read(String key);
  Future<Either> delete(String key);
}

class SecureServiceImpl extends SecureStorageDataSource {
  FlutterSecureStorage? _secureStorage;

  static final SecureServiceImpl _instance = SecureServiceImpl._();

  SecureServiceImpl._();

  factory SecureServiceImpl() {
    return _instance;
  }

  Future<void> init() async {
    _secureStorage = const FlutterSecureStorage();
  }

  @override
  Future<Either> write(String key, String value) async {
    try {
      await _secureStorage?.write(key: key, value: value);
      return const Right(null);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> read(String key) async {
    try {
      final String? response = await _secureStorage?.read(key: key);

      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> delete(String key) async {
    try {
      await _secureStorage?.delete(key: key);
      return const Right(null);
    } catch (e) {
      return Left(e);
    }
  }
}
