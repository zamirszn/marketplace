import 'package:dartz/dartz.dart';

abstract class SecureStorageRepository {
  Future<Either> write(String key, String value);
  Future<Either> read(String key);
  Future<Either> delete(String key);
}
