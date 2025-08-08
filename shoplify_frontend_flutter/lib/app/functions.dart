import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';


num calculateProductRange(num range) {
  return (range * 1000).ceil();
}

num calculateProductAmountByQuantity(num productPrice, int quantity) {
  return productPrice * quantity;
}

int calculateRatingPercentage(List<Review> reviews, num rating) {
  if (reviews.isEmpty) return 0;
  int countMatch =
      reviews.where((review) => review.rating?.floor() == rating).length;

  return ((countMatch / reviews.length) * 100).round();
}

String? sortReviewByDate(String? selectedOption) {
  switch (selectedOption) {
    case 'Newest':
      return "-date_created";
    case "Oldest":
      return "date_created";

    default:
      return null;
  }
}

num? sortReviewsByStar(String? selectedOption) {
  switch (selectedOption) {
    case '5 stars':
      return 5.0;
    case "4 stars":
      return 4.0;
    case "3 stars":
      return 3.0;
    case "2 stars":
      return 2.0;
    case "1 stars":
      return 1.0;

    default:
      return null;
  }
}

String formatDateDDMMMYYY(DateTime date) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}

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

String? emailValidator(
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

OutlineInputBorder outlineInputBorder({Color? color, double? width}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: width ?? AppSize.s2,
      color: color ?? ColorManager.grey,
    ),
    borderRadius: BorderRadius.circular(AppSize.s10),
  );
}

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

final cursorColor = ColorManager.white;

void logoutUser(BuildContext context) async {
  removeAuthToken();
  goto(context, Routes.loginPage);
}

void removeAuthToken() async {
  await sl<SecureStorageDataSource>().delete(
    Constant.accessToken,
  );
}

String? roundToTwoDecimalPlaces(num? number) {
  return number?.toStringAsFixed(2);
}
