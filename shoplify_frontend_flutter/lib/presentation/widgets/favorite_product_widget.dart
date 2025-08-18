import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/blur_background_widget.dart';
import 'package:shoplify/presentation/widgets/remove_favorite_product/remove_favorite_product_widget.dart';

class FavoriteProductWidget extends StatelessWidget {
  const FavoriteProductWidget({super.key, required this.product});
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (product != null) {
              context
                  .read<ProductDetailsBloc>()
                  .add(SetProductDetailsEvent(product: product!));
              goPush(context, Routes.productDetailsPage,
                  extra: {'heroTag': '${product?.id}_favorite'});
            }
          },
          child: Hero(
            tag: '${product?.id}_favorite',
            child: SizedBox(
              height: 600,
              width: 400,
              child: CachedNetworkImage(
                imageUrl: product?.images.first.image ?? "",
                height: AppSize.s100,
                width: AppSize.s100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: AppSize.s100,
                  width: AppSize.s100,
                  color: colorScheme.error,
                ),
                placeholder: (
                  context,
                  url,
                ) =>
                    Container(
                  color: colorScheme.secondary,
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
                  productId: product!.id!,
                ))),
        if (product?.price != null)
          Positioned(
              bottom: AppPadding.p20,
              left: AppPadding.p20,
              child: BlurBackgroundWidget(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p5),
                  child: Text(
                    "\$${roundToTwoDecimalPlaces(product?.price) ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(context,
                        color: ColorManager.white,
                        fontSize: FontSize.s23,
                        font: FontConstants.ojuju),
                  ),
                ),
              )),
        if (product?.name != null)
          Positioned(
            top: AppPadding.p20,
            right: AppPadding.p10,
            child: BlurBackgroundWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p5),
                child: Text(
                  product?.name?.toString() ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(context,
                      color: ColorManager.white,
                      fontSize: FontSize.s18,
                      font: FontConstants.ojuju),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
