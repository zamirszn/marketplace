import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.rating,
  });
  final num rating;

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating.floor()) {
        stars.add(Icon(
          Iconsax.star1,
          size: AppSize.s16,
          color: ColorManager.secondary,
        ));
      } else if (i < rating && rating - i >= .5) {
        stars.add(Icon(
          Iconsax.star_11,
          size: AppSize.s12,
          color: ColorManager.secondary,
        ));
      } else {
        stars.add(Padding(
          padding: const EdgeInsets.only(left: 1, top: .5),
          child: Icon(
            Iconsax.star,
            size: AppSize.s12,
            color: ColorManager.black.withOpacity(.7),
          ),
        ));
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}
