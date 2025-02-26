import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyOtpParams {
  final String email;
  final int otp;
  VerifyOtpParams({
    required this.email,
    required this.otp,
  });
  

  VerifyOtpParams copyWith({
    String? email,
    int? otp,
  }) {
    return VerifyOtpParams(
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'otp': otp,
    };
  }

  factory VerifyOtpParams.fromMap(Map<String, dynamic> map) {
    return VerifyOtpParams(
      email: map['email'] as String,
      otp: map['otp'] as int,
    );
  }

  }