import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_button.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
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
          extra: {'heroTag': '${product.id}_all'},
        );
      },
      child: Hero(
        tag: '${product.id}_all',
        child: Interactive3DEffect(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(AppSize.s20)),
            padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p12, horizontal: AppPadding.p12),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: RoundCorner(
                          child: FractionallySizedBox(
                            widthFactor: .98,
                            child: CachedNetworkImage(
                              imageUrl: product.images.isNotEmpty
                                  ? product.images.first.image!
                                  : "",
                              height: AppSize.s120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Skeletonizer(
                                  child: Container(
                                color: ColorManager.darkBlue,
                                height: AppSize.s100,
                                width: AppSize.s100,
                              )),
                              errorWidget: (context, url, error) => Container(
                                color: ColorManager.darkBlue,
                                height: AppSize.s100,
                                width: AppSize.s100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      space(h: AppSize.s10),
                      Text(
                        product.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(),
                      ),
                      if (product.description != null)
                        Text(
                          product.description ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: AppSize.s100),
                            child: Text(
                              "\$${roundToTwoDecimalPlaces(product.price)}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: FontSize.s18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontConstants.ojuju),
                            ),
                          ),
                          if (product.discount == true)
                            Text(
                              "\$${roundToTwoDecimalPlaces(product.oldPrice)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: product.discount != null &&
                                          product.discount == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: FontSize.s14,
                                  fontFamily: FontConstants.ojuju),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: RoundCorner(child: AddToCartWidget(product: product)),
                ),
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: StarRatingWidget(rating: product.averageRating ?? 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
