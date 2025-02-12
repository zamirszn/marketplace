
import 'package:flutter/material.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductWidgetSkeleton extends StatelessWidget {
  const ProductWidgetSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Interactive3DEffect(
      child: Skeletonizer(
        child: Container(
          width: AppSize.s200,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(AppSize.s20)),
          padding: const EdgeInsets.symmetric(
              vertical: AppPadding.p12, horizontal: AppPadding.p12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RoundCorner(
                        child: Container(
                      color: ColorManager.white,
                      height: 100,
                      width: double.infinity,
                    )),
                  ),
                  space(h: AppSize.s10),
                  Text(
                    "******************",
                    style: getRegularStyle(fontSize: FontSize.s16),
                  ),
                  Text(
                    "********",
                    style: getRegularStyle(fontSize: FontSize.s16),
                  ),
                  space(h: AppSize.s20),
                  Row(
                    children: [
                      Text(
                        "*****",
                        style: getRegularStyle(fontSize: FontSize.s16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p10),
                        child: Text(
                          "*****",
                          style: getRegularStyle(fontSize: FontSize.s16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
