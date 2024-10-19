import 'package:dartz/dartz.dart';
import 'package:marketplace/domain/repository/secure_storage_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';

class SecureStorageRepositoryImpl extends SecureStorageRepository {
  @override
  Future<Either> delete(String key) async {
    Either result = await sl<SecureStorageDataSource>().delete(key);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      return const Right(null);
    });
  }

  @override
  Future<Either> read(String key) async {
    Either result = await sl<SecureStorageDataSource>().read(key);
    return result.fold((error) {
      return Left(error);
    }, (data) {
      String response = data;
      return Right(response);
    });
  }

  @override
  Future<Either> write(String key, String value) async {
    Either result = await sl<SecureStorageDataSource>().write(key, value);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      return const Right(null);
    });
  }
}
