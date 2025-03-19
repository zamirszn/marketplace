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
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/widgets/blur_background_widget.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/new_product_widget.dart';
import 'package:shoplify/presentation/widgets/remove_favorite_product/remove_favorite_product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoriteProductWidget extends StatelessWidget {
  const FavoriteProductWidget({super.key, required this.product});
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            context
                .read<ProductDetailsBloc>()
                .add(SetProductDetailsEvent(product: product));
            goPush(context, Routes.productDetailsPage,
                extra: {'heroTag': '${product.id}_favorite'});
          },
          child: Hero(
            
            tag: '${product.id}_favorite',
            child: SizedBox(
              height: 400,
              width: 400,
              child: CachedNetworkImage(
                imageUrl: product.images.first.image!,
                height: AppSize.s120,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: AppSize.s100,
                  width: AppSize.s100,
                  color: ColorManager.darkBlue,
                ),
                placeholder: (
                  context,
                  url,
                ) =>
                    Container(
                  color: ColorManager.darkBlue,
                  height: AppSize.s100,
                  width: AppSize.s100,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: AppPadding.p20,
            right: AppPadding.p10,
            child: BlurBackgroundWidget(
                width: AppSize.s40,
                child: RemoveFavoriteProductWidget(
                  productId: product.id!,
                ))),
        if (product.price != null)
          Positioned(
              bottom: AppPadding.p20,
              left: AppPadding.p10,
              child: BlurBackgroundWidget(
                child: Text(
                  "\$${product.price?.toString() ?? ""}",
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s23,
                      font: FontConstants.ojuju),
                ),
              )),
        if (product.name != null)
          Positioned(
            top: AppPadding.p20,
            right: AppPadding.p10,
            child: BlurBackgroundWidget(
              child: Text(
                product.name?.toString() ?? "",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s18,
                    font: FontConstants.ojuju),
              ),
            ),
          ),
      ],
    );
  }
}
