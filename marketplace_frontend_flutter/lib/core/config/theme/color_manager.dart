import 'package:flutter/material.dart';
import 'package:marketplace/app/extensions.dart';

class ColorManager {
  static Color secondary = HexColor.fromHex("#3D52A0").withOpacity(.6);
  static Color secondaryDark = HexColor.fromHex("#3D52A0");
  static Color grey = Colors.grey.shade600;
  static Color red = Colors.red;
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color primary = Colors.grey.shade300;
  static Color primaryDark = Colors.grey.shade400;
  static Color primaryLight = HexColor.fromHex("#EDE8F5").withOpacity(.99);
  static Color green = Colors.green.shade400;
}
