import 'package:marketplace/core/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalServiceDataSource {
  Future<bool> userDoneOnBoarding();
}

class AuthLocalServiceImpl extends AuthLocalServiceDataSource {
  @override
  Future<bool> userDoneOnBoarding() {
    // TODO: implement userDoneOnBoarding
    throw UnimplementedError();
  }
}
