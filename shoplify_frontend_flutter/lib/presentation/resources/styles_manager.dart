import 'package:flutter/material.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular style
TextStyle getRegularStyle(
  BuildContext context, {
  double fontSize = FontSize.s12,
  Color? color,
  String font = FontConstants.poppins,
}) {
  final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
  return _getTextStyle(
      fontSize, font, FontWeightManager.regular, resolvedColor);
}

// light style
TextStyle getLightStyle(
  BuildContext context, {
  double fontSize = FontSize.s12,
  Color? color,
  String font = FontConstants.poppins,
}) {
  final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
  return _getTextStyle(fontSize, font, FontWeightManager.light, resolvedColor);
}

// bold style
TextStyle getBoldStyle(
  BuildContext context, {
  double fontSize = FontSize.s12,
  Color? color,
  String font = FontConstants.poppins,
}) {
  final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
  return _getTextStyle(fontSize, font, FontWeightManager.bold, resolvedColor);
}

// semi bold style
TextStyle getSemiBoldStyle(
  BuildContext context, {
  double fontSize = FontSize.s12,
  Color? color,
  String font = FontConstants.poppins,
}) {
  final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
  return _getTextStyle(
      fontSize, font, FontWeightManager.semiBold, resolvedColor);
}

// medium style
TextStyle getMediumStyle(
  BuildContext context, {
  double fontSize = FontSize.s12,
  Color? color,
  String font = FontConstants.poppins,
}) {
  final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
  return _getTextStyle(fontSize, font, FontWeightManager.medium, resolvedColor);
}
