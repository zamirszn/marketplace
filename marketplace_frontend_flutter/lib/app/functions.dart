import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/resources/asset_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({
    required super.builder,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}





bool validateUsername(String username) {
  return username.isNotEmpty && username.contains('@');
}

bool validateFullName(String fullName) {
  return fullName.isNotEmpty; // Adjust validation as needed
}

bool validateEmail(String email) {
  return email.isNotEmpty && email.contains('@'); // Basic email validation
}

bool validatePassword(String password) {
  return password.length >= 6; // Password should be at least 6 characters
}

String? phoneValidator(
  String? value,
) {
  if (value!.isEmpty) {
    return '${AppStrings.phoneNumber} is required';
  } else if (value.length < 3) {
    return 'Please enter a valid ${AppStrings.phoneNumber}';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    return 'Password is required';
  } else if (!eightCharacterRegex.hasMatch(value)) {
    return "Password must be at least 8 characters";
  } else if (!upperCaseRegex.hasMatch(value)) {
    return "Password must contain at least one upper case character";
  } else if (!lowerCaseRegex.hasMatch(value)) {
    return "Password must contain at least one lower case character";
  } else if (!oneDigitRegex.hasMatch(value)) {
    return "Password must contain at least one digit";
  } else if (!specialCharacterRegex.hasMatch(value)) {
    return "Password must contain at least one special character";
  }
  return null;
}

String? emailNameValidator(
  String? value,
) {
  if (value!.isEmpty) {
    return '${AppStrings.emailAddress} is required';
  } else if (value.length < 3) {
    return 'Please enter your ${AppStrings.emailAddress}';
  } else if (!value.contains("@")) {
    return "Please enter a valid ${AppStrings.emailAddress}";
  }
  return null;
}

String? nameValidator(
  String? value,
) {
  if (value!.isEmpty) {
    return '${AppStrings.fullName} is required';
  }
  return null;
}

SizedBox space({double h = 0, double w = 0}) {
  return SizedBox(
    width: w,
    height: h,
  );
}

SliverToBoxAdapter sliverSpace({double h = 0, double w = 0}) {
  return SliverToBoxAdapter(
    child: SizedBox(
      width: w,
      height: h,
    ),
  );
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

UnderlineInputBorder noOutlineInput = UnderlineInputBorder(
  borderSide: BorderSide(
    width: 0,
    color: Colors.green.shade300,
  ),
  borderRadius: BorderRadius.circular(AppSize.s10),
);

final RegExp oneDigitRegex = RegExp(r'^(?=.*?[0-9])');
final RegExp upperCaseRegex = RegExp(r'^(?=.*[A-Z])');
final RegExp lowerCaseRegex = RegExp(r'^(?=.*[a-z])');
final RegExp specialCharacterRegex = RegExp(r'^(?=.*?[!@#\$&*~])');
final RegExp eightCharacterRegex = RegExp(r'^.{8,}');
final RegExp dateFormatRegex =
    RegExp(r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$');

final FilteringTextInputFormatter textWithSpaceInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

final FilteringTextInputFormatter textOnlyInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'));
