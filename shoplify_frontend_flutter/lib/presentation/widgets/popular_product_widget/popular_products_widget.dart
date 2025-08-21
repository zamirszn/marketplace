import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/favorite_button.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';

class PopularProductsWidget extends StatelessWidget {
  const PopularProductsWidget({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        context
            .read<ProductDetailsBloc>()
            .add(SetProductDetailsEvent(product: product));
        goPush(
          context,
          Routes.productDetailsPage,
          extra: {'heroTag': '${product.id}_popular'},
        );
      },
      child: Hero(
        tag: '${product.id}_popular',
        child: Container(
          width: AppSize.s250,
          decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(AppSize.s20)),
          padding: const EdgeInsets.symmetric(
              vertical: AppPadding.p12, horizontal: AppPadding.p12),
          child: Stack(
            children: [
              Row(
                children: [
                  RoundCorner(
                    child: CachedNetworkImage(
                      imageUrl: product.images.isNotEmpty
                          ? product.images.first.image!
                          : "",
                      height: AppSize.s100,
                      width: AppSize.s60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: colorScheme.secondary,
                        height: AppSize.s100,
                        width: AppSize.s50,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: colorScheme.error,
                        height: AppSize.s100,
                        width: AppSize.s50,
                      ),
                    ),
                  ),
                  space(w: AppSize.s10),
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: AppSize.s130,
                          child: Text(
                            product.name ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StarRatingWidget(rating: product.averageRating ?? 0),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.discountedPrice != null)
                                  Text(
                                    "\$${roundToTwoDecimalPlaces(product.price)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        decoration:
                                            product.discountedPrice != null
                                                ? TextDecoration.lineThrough
                                                : null,
                                        fontSize: FontSize.s12,
                                        fontFamily: FontConstants.ojuju),
                                  ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: AppSize.s90),
                                  child: Text(
                                    product.discountedPrice != null
                                        ? "\$${roundToTwoDecimalPlaces(product.discountedPrice)}"
                                        : "\$${roundToTwoDecimalPlaces(product.price)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: FontSize.s16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: FontConstants.ojuju),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 2,
                  child: FavoriteButton(
                    product: product,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
