import 'package:flutter/material.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';

class Constant {
  static const String xAuthToken = "x-auth-token";
  static const String appName = "Market Place";
  static int phoneLength = 20;
  static int passwordLength = 20;
  static int nameLength = 50;
  static int emailNameLength = 50;
  static int paginationLimit = 50;
  static int verificationCodeLimit = 6;
  static String success = "success";
  static List<String> imageExtenstions = [
    "img",
    "png",
    "webp",
    "jpeg",
    "jpg",
    "img"
  ];

  static List<BoxShadow> boxShadow1 = [
    BoxShadow(
      color: ColorManager.color2, // The color with the opacity
      offset: const Offset(0, 9), // The horizontal and vertical offset
      blurRadius: 10, // The blur radius
      spreadRadius: 0, // The spread radius
    )
  ];
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
}
