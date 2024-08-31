import 'dart:ui';

import 'package:marketplace/data/network/api_response_status.dart';
import 'package:marketplace/data/request/auth_service.dart';
import 'package:marketplace/providers/base_provider.dart';

class AuthProvider extends DisposableProvider {
  bool isPasswordVisible = false;

  void setPasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

// signup
  void signUp({
    required String fullName,
    required String email,
    
    required String password,
  }) async {
    final response = await authService.signUp(
        fullName: fullName, email: email, password: password);

    if (response is Success) {}
  }

// login

  @override
  void disposeValues() {}
}
