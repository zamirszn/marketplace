import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularProductsWidget extends StatelessWidget {
  const PopularProductsWidget({
    super.key,
    required this.product,
  });
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
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
        child: Interactive3DEffect(
          child: Container(
            width: AppSize.s250,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
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
                        width: AppSize.s50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: ColorManager.white,
                          height: AppSize.s100,
                          width: AppSize.s50,
                        ),
                        errorWidget: (context, url, error) => Skeletonizer(
                            child: Container(
                          color: ColorManager.white,
                          height: AppSize.s100,
                          width: AppSize.s50,
                        )),
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
                            width: AppSize.s140,
                            child: Text(
                              product.name ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.discount == true)
                                    Text(
                                      "\$${roundToTwoDecimalPlaces(product.oldPrice)}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decoration:
                                              product.discount != null &&
                                                      product.discount == true
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                          fontSize: FontSize.s12,
                                          fontFamily: FontConstants.ojuju),
                                    ),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxWidth: AppSize.s90),
                                    child: Text(
                                      "\$${roundToTwoDecimalPlaces(product.price)}",
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
                    top: 0,
                    right: 2,
                    child:
                        StarRatingWidget(rating: product.averageRating ?? 0)),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(Iconsax.heart)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
