// ignore_for_file: public_member_api_docs, sort_constructors_first

class SignupParamsModel {
  final String fullName;
  final String email;
  final String password;
  SignupParamsModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  SignupParamsModel copyWith({
    String? fullName,
    String? email,
    String? password,
  }) {
    return SignupParamsModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'password': password,
    };
  }
}
