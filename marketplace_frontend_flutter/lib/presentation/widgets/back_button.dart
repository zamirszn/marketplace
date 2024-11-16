import 'package:flutter/material.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: RoundCorner(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => goPopRoute(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: color ?? ColorManager.black,
              size: AppSize.s20,
            )),
      ),
    );
  }
}
