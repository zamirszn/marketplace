import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback? retry;
  final String? message;

  const RetryButton({super.key, this.retry, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(Iconsax.link),
          onPressed: () {
            if (retry != null) {
              retry!();
            }
          },
          label: Text(
            AppStrings.retry,
            style: getRegularStyle(
                color: ColorManager.black, font: FontConstants.poppins),
          ),
        ),
        space(h: AppSize.s20),
        Text(
          message ?? AppStrings.somethingWentWrong,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
              color: ColorManager.black, font: FontConstants.poppins),
        )
      ],
    );
  }
}
