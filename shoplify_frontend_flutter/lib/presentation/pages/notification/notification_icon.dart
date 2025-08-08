import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: const Text("3"),
      alignment: const AlignmentDirectional(.7, -.8),
      backgroundColor: ColorManager.blue,
      textColor: ColorManager.white,
      textStyle: getRegularStyle(context, font: FontConstants.ojuju),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.notification),
      ),
    );
  }
}
