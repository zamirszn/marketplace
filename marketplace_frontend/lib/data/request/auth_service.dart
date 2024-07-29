import 'package:marketplace/data/network/base_client.dart';
import 'package:marketplace/data/request/secure_storage_service.dart';

class AuthService {
  Future<Object?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    var response = await baseClient.postRequest(endpoint: "/signup", payload: {
      "fullName": fullName,
      "email": email,
      "password": password,
    });

    return response;
  }

  Future<Object?> login({
    required String email,
    required String password,
  }) async {
    var response = await baseClient.postRequest(endpoint: "/login", payload: {
      "email": email,
      "password": password,
    });

    return response;
  }

  Future<Object?> refreshToken() async {
    final String? refreshToken =
        await secureStorageService.readSecureData(key: "refreshToken");
    var response =
        await baseClient.postRequest(endpoint: "/refreshToken", payload: {
      "refreshToken": refreshToken,
    });

    return response;
  }

  Future<Object?> sendOTP({
    required String email,
    required String password,
  }) async {
    var response = await baseClient.postRequest(endpoint: "/sendOTP", payload: {
      "email": email,
    });

    return response;
  }

  Future<Object?> verifyOTP({
    required String email,
    required String otp,
  }) async {
    var response =
        await baseClient.postRequest(endpoint: "/verifyOTP", payload: {
      "email": email,
      "otp": otp,
    });

    return response;
  }

  Future<Object?> userProfile() async {
    var response = await baseClient.getRequest(
      endpoint: "/userProfile",
    );

    return response;
  }
}

final AuthService authService = AuthService();
