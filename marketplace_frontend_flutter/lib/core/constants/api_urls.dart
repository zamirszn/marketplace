import 'package:flutter/foundation.dart';

class ApiUrls {
  static const String prodBaseUrl = "https://marketplace-pwmk.onrender.com/";
  static const String baseUrl = "http://127.0.0.1:8000/";
  static const String auth = "auth";
  static const String api = "api";
  static const String products = "products";
  static const String reviews = "reviews";
  static const String cart = "cart";
  static const String items = "items";
  static const String register = "$auth/signup/";
  static const String login = "$auth/jwt/create";
  static const String refreshToken = "$auth/jwt/refresh";
  static const String userProfile = "$auth/users";
  static const String categories = "$api/categories";
  static const String newProducts = "$api/$products/new-products";
  static const String popularProducts = "$api/$products/popular-products";
  static const String allProducts = "$api/$products";
  static const String cartUrl = "$api/$cart";
}
