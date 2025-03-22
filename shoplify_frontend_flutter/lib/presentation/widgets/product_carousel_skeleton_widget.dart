
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCarouselSkeletonWidget extends StatelessWidget {
  const ProductCarouselSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          child: Container(
            color: ColorManager.white,
            height: 400,
            width: 400,
          ),
        ),
        const Positioned(
          bottom: AppPadding.p20,
          right: AppPadding.p30,
          child: Skeletonizer(
              effect: PulseEffect(),
              child: Icon(
                Iconsax.save_minus,
                size: AppSize.s36,
              )),
        ),
        Positioned(
            bottom: AppPadding.p20,
            left: AppPadding.p10,
            child: Skeletonizer(
              effect: const PulseEffect(),
              child: Text(
                "*******",
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                    fontSize: FontSize.s23, font: FontConstants.ojuju),
              ),
            )),
        Positioned(
          top: AppPadding.p20,
          right: AppPadding.p30,
          child: Skeletonizer(
            effect: const PulseEffect(),
            child: Text(
              "*******",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                  fontSize: FontSize.s18, font: FontConstants.ojuju),
            ),
          ),
        ),
      ],
    );
  }
}
