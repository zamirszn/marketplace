import 'package:flutter/material.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';

void showMessage(
  BuildContext context,
  String message,
) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: ColorManager.color2,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
        bottom: 30), // Adjust the top margin to position it below the app bar
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorMessage(
  BuildContext context,
  String message,
) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: ColorManager.red,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
        bottom: 30), // Adjust the top margin to position it below the app bar
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
