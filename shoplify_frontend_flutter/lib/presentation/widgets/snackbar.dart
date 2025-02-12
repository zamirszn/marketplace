import 'package:flutter/material.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

void showMessage(
  BuildContext context,
  String message,
) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: ColorManager.secondaryDark,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.horizontal,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s16)),
    margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
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
    dismissDirection: DismissDirection.horizontal,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s16)),

    margin: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20), // Adjust the top margin to position it below the app bar
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
