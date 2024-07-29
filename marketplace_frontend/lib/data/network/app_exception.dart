class AppException implements Exception {
  final String? message;
  final String? url;

  AppException({this.message, this.url});
}

const String badRequest = "Bad Request";
const String notFound = "Not Found";
const String serverError = "Server Error";
const String uncaught = "Server Error";
const String unAuthorizedRequest = "Unauthorized Request";
const String unknownError = "Unknown Error";
const String noInternetConnection = "No Internet Connection";
const String requestTimeout = "Request Timed Out";
const String invalidRequest = "Invalid Request";
const String somethingWentWrong = "Something Went Wrong";
