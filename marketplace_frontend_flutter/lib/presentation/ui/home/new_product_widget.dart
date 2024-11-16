import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/core/constants/api_urls.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/auth/login/login_page.dart';
import 'package:marketplace/presentation/ui/home/bloc/product_bloc.dart';
import 'package:marketplace/presentation/ui/home/home_page.dart';
import 'package:marketplace/presentation/ui/home/product_widget.dart';
import 'package:marketplace/presentation/widgets/3d_flip_widget.dart';
import 'package:marketplace/presentation/widgets/favourite_button.dart';
import 'package:marketplace/presentation/widgets/interactive_3d_effect.dart';
import 'package:marketplace/presentation/ui/home/product_details_page.dart';
import 'package:marketplace/presentation/widgets/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewProductWidget extends StatelessWidget {
  const NewProductWidget({
    super.key,
    required this.product,
  });
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goPush(
          context,
          Routes.productDetailsPage,
          extra: {'product': product, 'heroTag': '${product.id}_new'},
        );
      },
      child: Hero(
        tag: '${product.id}_new',
        child: Interactive3DEffect(
          child: Container(
            width: AppSize.s200,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(AppSize.s20)),
            padding: EdgeInsets.symmetric(
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
                          child: CachedNetworkImage(
                            imageUrl: product.images.isNotEmpty
                                ? product.images.first.image!
                                : "",
                            height: AppSize.s120,
                            width: AppSize.s200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                              child: Container(
                                color: ColorManager.white,
                                height: AppSize.s100,
                                width: AppSize.s100,
                              ),
                            ),
                            errorWidget: (context, url, error) => Skeletonizer(
                                child: Container(
                              color: ColorManager.white,
                              height: AppSize.s100,
                              width: AppSize.s100,
                            )),
                          ),
                        ),
                      ),
                      space(h: AppSize.s10),
                      Text(
                        product.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            "\$${product.price}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: FontSize.s18,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontConstants.ojuju),
                          ),
                          if (product.discount == true)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: AppPadding.p10),
                              child: Text(
                                "\$${product.oldPrice}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    decoration: product.discount != null &&
                                            product.discount == true
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontSize: FontSize.s14,
                                    fontFamily: FontConstants.ojuju),
                              ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          padding: EdgeInsets.symmetric(
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







