import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/interactive_3d_effect.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularProductsWidget extends StatelessWidget {
  const PopularProductsWidget({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Interactive3DEffect(
      child: Container(
        width: AppSize.s250,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(AppSize.s20)),
        padding: EdgeInsets.symmetric(
            vertical: AppPadding.p12, horizontal: AppPadding.p12),
        child: Stack(
          children: [
            Row(
              children: [
                RoundCorner(
                  child: CachedNetworkImage(
                    imageUrl: product.image ?? "",
                    height: 100,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      child: FlutterLogo(),
                    ),
                    errorWidget: (context, url, error) => Skeletonizer(
                        child: Container(
                      color: ColorManager.white,
                      height: 100,
                      width: 50,
                    )),
                  ),
                ),
                space(w: AppSize.s10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: AppSize.s140,
                      child: Text(
                        product.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${product.price}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              decoration: product.discountPrice != null
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontSize: FontSize.s18,
                              fontFamily: FontConstants.ojuju),
                        ),
                        if (product.discountPrice != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: AppPadding.p10),
                            child: Text(
                              "\$${product.discountPrice.toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: FontSize.s18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontConstants.ojuju),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
    );
  }
}
