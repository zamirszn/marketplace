import 'package:flutter/material.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => goPopRoute(context),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: color ?? ColorManager.black,
          size: AppSize.s20,
        ));
  }
}
