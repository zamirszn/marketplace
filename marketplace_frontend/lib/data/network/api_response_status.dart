
class Success {
  int? code;
  Map<String, dynamic>? responseData;
  String? message;
  Success({this.code, this.message, required this.responseData});
}

class Failure {
  int? code;
  String? message;

  Failure({required this.code, required this.message});
}
