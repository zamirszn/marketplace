import 'package:dartz/dartz.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefDataSource {
  Future<Either<Exception, bool?>> writeBool(String key, bool value);
  Future<Either<Exception, bool?>> readBool(String key);
  Future<Either<Exception, bool?>> delete(String key);
}

class SharePrefImpl extends SharedPrefDataSource {
  SharedPreferences? _sharedPref;
  static final SharePrefImpl _instance = SharePrefImpl._();

  SharePrefImpl._();

  factory SharePrefImpl() {
    return _instance;
  }

  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  @override
  Future<Either<Exception, bool?>> writeBool(String key, bool value) async {
    try {
      final response = await _sharedPref?.setBool(key, value);
      return Right(response);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool?>> readBool(String key) async {
    try {
      final response = await _sharedPref?.getBool(key);
      return Right(response);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool?>> delete(String key) async {
    try {
      final response = await _sharedPref?.remove(key);
      return Right(response);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
