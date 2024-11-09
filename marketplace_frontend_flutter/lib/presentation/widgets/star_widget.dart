import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating});
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
          size: AppSize.s16,
          color: ColorManager.secondary,
        ));
      } else {
        stars.add(Icon(
          Iconsax.star,
          size: AppSize.s12,
          color: Colors.black,
        ));
      }
    }
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p5),
      child: Row(children: stars),
    );
  }
}
