import 'package:dio/dio.dart';
import 'package:marketplace/app/constant.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioFactory {
  Dio dio = Dio();
  String? _token;

  Dio getDio() {
    Duration timeOut = const Duration(minutes: 1);
    Map<String, String> headers = {
      contentType: applicationJson,
      // accept: applicationJson,
      authorization: _token ?? "",
    };

    dio.options = BaseOptions(
        validateStatus: (status) {
          // Return true if you want to accept the status code,
          // otherwise return false to let Dio throw an exception.
          return true;
        },
        baseUrl: Constant.baseUrl,
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
        headers: headers);

    return dio;
  }

  void setToken(String token) {
    _token = "Bearer $token";
    dio.options.headers[authorization] = _token;
  }
}

final DioFactory dioFactory = DioFactory();
final Dio dioObj = dioFactory.getDio();
