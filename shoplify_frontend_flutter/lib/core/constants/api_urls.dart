class ApiUrls {
  static const String prodBaseUrl = "https://shoplify-pwmk.onrender.com/";
  static const String baseUrl = "http://127.0.0.1:8000/";
  static const String auth = "auth";
  static const String api = "api";
  static const String products = "products";
  static const String reviews = "reviews";
  static const String cart = "cart";
  static const String items = "items";
  static const String getProfile = "profile/";
  static const String register = "$auth/signup/";
  static const String login = "$auth/login/";
  static const String refreshToken = "$auth/jwt/refresh";
  static const String categories = "$api/categories";
  static const String newProducts = "$api/$products/new-products";
  static const String popularProducts = "$api/$products/popular-products";
  static const String allProducts = "$api/$products";
  static const String favorites = "$api/favorites";
  static const String cartUrl = "$api/$cart";
  static const String requestEmailActivationOTP =
      "$auth/request-email-verification-otp/";
  static const String verifyEmail = "$auth/verify-email/";
  static const String requestNewPasswordOTP =
      "$auth/request-password-reset-otp/";
  static const String resetPassword = "$auth/reset-password/";
}
