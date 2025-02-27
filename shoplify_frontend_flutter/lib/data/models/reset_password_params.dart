// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResetPasswordParams {
  final String password;
  final int otp;
  final String email;
  ResetPasswordParams({
    required this.password,
    required this.otp,
    required this.email,
  });

  ResetPasswordParams copyWith({
    String? password,
    int? otp,
    String? email,
  }) {
    return ResetPasswordParams(
      password: password ?? this.password,
      otp: otp ?? this.otp,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'password': password,
      'otp': otp,
      'email': email,
    };
  }

  factory ResetPasswordParams.fromMap(Map<String, dynamic> map) {
    return ResetPasswordParams(
      password: map['password'] as String,
      otp: map['otp'] as int,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordParams.fromJson(String source) =>
      ResetPasswordParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NewPasswordParams(password: $password, otp: $otp, email: $email)';

  @override
  bool operator ==(covariant ResetPasswordParams other) {
    if (identical(this, other)) return true;

    return other.password == password &&
        other.otp == otp &&
        other.email == email;
  }

  @override
  int get hashCode => password.hashCode ^ otp.hashCode ^ email.hashCode;
}
