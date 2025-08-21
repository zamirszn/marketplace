import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Constant {
  static const double maxFileSizeMB = 2.0;
  static const double maxImageSizeMB = 5.0;
  static const String doneOnboarding = "doneOnboarding";
  static const String accessToken = "access";
  static const String refreshToken = "refresh";
  static const String emailVerified = "email_verified";
  static const String accountBlocked = "account_blocked";
  static const String appName = "Shoplify";
  static int otpCountdown = 60;
  static int phoneLength = 16;
  static int passwordLength = 20;
  static int nameLength = 50;
  static int emailLength = 50;
  static int addressLength = 200;
  static int paginationLimit = 50;
  static int verificationCodeLimit = 6;
  static String success = "success";
  static const double sliderMaxRange = 10000;

  static List<String> imageExtenstions = [
    "img",
    "png",
    "webp",
    "jpeg",
    "jpg",
    "img"
  ];

  // static List<BoxShadow> boxShadow1 = [
  //   BoxShadow(
  //     color: ColorManager.col, // The color with the opacity
  //     offset: const Offset(0, 9), // The horizontal and vertical offset
  //     blurRadius: 10, // The blur radius
  //     spreadRadius: 0, // The spread radius
  //   )
  // ];
  static List<BoxShadow> boxShadow2 = const [
    BoxShadow(
      color: Colors.black12, // The color with the opacity
      offset: Offset(1, 2), // The horizontal and vertical offset
      blurRadius: 5, // The blur radius
      spreadRadius: 0, // The spread radius
    )
  ];

  static List<BoxShadow> boxShadow3 = [
    const BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 9), // The horizontal and vertical offset
      blurRadius: 10, // The blur radius
      spreadRadius: 0,
    ),
  ];

  static final ShakeEffect shakeEffect = ShakeEffect(
      rotation: 0, duration: 500.ms, hz: 5, offset: const Offset(10, 0));
}

enum PasswordVisibility { on, off }

enum OTPComplete { incomplete, complete }
