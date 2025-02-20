import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/blur_background_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_button.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:shoplify/presentation/widgets/remove_favorite_product/remove_favorite_product_widget.dart';
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
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              width: 300,
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
            // Positioned(
            //     bottom: AppPadding.p20,
            //     right: AppPadding.p10,
            //     child: BlurBackgroundWidget(
            //         width: AppSize.s40,
            //         child: AddToCartWidget(
    
            //           product: product,
            //         ))),
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
        ),
      ),
    );
  }
}
