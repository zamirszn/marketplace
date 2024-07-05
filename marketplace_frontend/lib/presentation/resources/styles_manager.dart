import 'package:flutter/material.dart';

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
    required Color color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(fontSize, font, FontWeightManager.regular, color);
}
// light text style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(
      fontSize, FontConstants.poppins, FontWeightManager.light, color);
}
// bold text style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(fontSize, font, FontWeightManager.bold, color);
}

// semi bold text style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(fontSize, font, FontWeightManager.semiBold, color);
}

// medium text style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String font = FontConstants.poppins}) {
  return _getTextStyle(fontSize, font, FontWeightManager.medium, color);
}
