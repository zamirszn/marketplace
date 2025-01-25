// ignore_for_file: public_member_api_docs, sort_constructors_first

class LoginParamsModel {
  final String email;
  final String password;
  LoginParamsModel({
    required this.email,
    required this.password,
  });

  LoginParamsModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginParamsModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory LoginParamsModel.fromMap(Map<String, dynamic> map) {
    return LoginParamsModel(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
