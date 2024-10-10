import 'package:flutter/material.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight);
}

// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s12,
    Color? color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(
      fontSize, font, FontWeightManager.regular, color ?? ColorManager.black);
}
// light text style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12,
    Color? color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(fontSize, FontConstants.poppins, FontWeightManager.light,
      color ?? ColorManager.black);
}
// bold text style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s12,
    Color? color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(
      fontSize, font, FontWeightManager.bold, color ?? ColorManager.black);
}

// semi bold text style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12,
    Color? color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(
      fontSize, font, FontWeightManager.semiBold, color ?? ColorManager.black);
}

// medium text style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12,
    Color? color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(
      fontSize, font, FontWeightManager.medium, color ?? ColorManager.black);
}
