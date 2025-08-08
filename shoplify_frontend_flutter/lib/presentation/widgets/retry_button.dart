import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
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
        Text(
          message ?? AppStrings.somethingWentWrong,
          textAlign: TextAlign.center,
          style: getRegularStyle(context,
              font: FontConstants.poppins, fontSize: FontSize.s20),
        ),
        space(h: AppSize.s40),
        SizedBox(
          width: double.infinity,
          height: AppSize.s40,
          child: OutlinedButton.icon(
            icon: const Icon(
              Iconsax.link,
              size: AppSize.s28,
            ),
            onPressed: () {
              if (retry != null) {
                retry!();
              }
            },
            label: Text(
              AppStrings.retry,
              style: getMediumStyle(context,
                  font: FontConstants.ojuju, fontSize: FontSize.s16),
            ),
          ),
        ),
      ],
    );
  }
}
