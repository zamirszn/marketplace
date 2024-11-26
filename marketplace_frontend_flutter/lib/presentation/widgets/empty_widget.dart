import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.message, this.icon});
  final String? message;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
          child: icon ??
              Icon(
                Iconsax.shop_add,
                size: AppSize.s40,
              ),
        ),
        Text(
          message ?? AppStrings.emptyMessage,
          style: getRegularStyle(color: ColorManager.black),
        )
      ],
    );
  }
}
