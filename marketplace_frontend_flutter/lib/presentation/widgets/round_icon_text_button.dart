import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class RoundIconTextButton extends StatelessWidget {
  const RoundIconTextButton(
      {super.key,
      this.iconData,
      required this.text,
      required this.onPressed,
      this.bgColor,
      this.textColor,
      this.iconColor,
      this.iconAlignment});
  final IconData? iconData;
  final String text;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? textColor;
  final Color? iconColor;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton.icon(
            iconAlignment: iconAlignment ?? IconAlignment.start,
            style: ElevatedButton.styleFrom(
                backgroundColor: bgColor ?? ColorManager.black),
            icon: const SizedBox(
              height: 50,
              width: 50,
            ),
            onPressed: onPressed,
            label: Text(
              text,
              style: getRegularStyle(
                  color: textColor ?? ColorManager.white,
                  font: FontConstants.ojuju,
                  fontSize: FontSize.s16),
            )),
        Positioned(
          left: iconAlignment == IconAlignment.start ? 1 : null,
          right: iconAlignment == IconAlignment.end ? 1 : null,
          child: GestureDetector(
            onTap: onPressed,
            child: Transform.scale(
              scale: .8,
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: textColor),
                child: Icon(
                  iconData,
                  color: iconColor ?? ColorManager.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
