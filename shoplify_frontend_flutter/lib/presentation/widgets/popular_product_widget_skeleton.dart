
import 'package:flutter/material.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularProductsWidgetSkeleton extends StatelessWidget {
  const PopularProductsWidgetSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Interactive3DEffect(
      child: Skeletonizer(
        child: Container(
          width: AppSize.s250,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(AppSize.s20)),
          padding: const EdgeInsets.symmetric(
              vertical: AppPadding.p12, horizontal: AppPadding.p12),
          child: Row(
            children: [
              RoundCorner(
                child: Container(
                  color: ColorManager.white,
                  height: AppSize.s100,
                  width: AppSize.s50,
                ),
              ),
              space(w: AppSize.s10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "*************",
                    style: getRegularStyle(fontSize: FontSize.s16),
                  ),
                  Text(
                    "********",
                    style: getRegularStyle(fontSize: FontSize.s16),
                  ),
                  space(h: AppSize.s20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
