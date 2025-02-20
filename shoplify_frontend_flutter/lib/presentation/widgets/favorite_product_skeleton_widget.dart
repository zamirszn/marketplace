import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/widgets/blur_background_widget.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/new_product_widget.dart';
import 'package:shoplify/presentation/widgets/remove_favorite_product/remove_favorite_product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoriteProductSkeletonWidget extends StatelessWidget {
  const FavoriteProductSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          child: Container(
            color: Colors.white,
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
