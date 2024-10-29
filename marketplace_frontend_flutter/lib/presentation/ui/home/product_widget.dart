import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/3d_flip_widget.dart';
import 'package:marketplace/presentation/widgets/favourite_button.dart';
import 'package:marketplace/presentation/widgets/interactive_3d_effect.dart';
import 'package:marketplace/presentation/ui/home/item_details_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Interactive3DEffect(
      child: Container(
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
                    child: FractionallySizedBox(
                      widthFactor: .98,
                      child: CachedNetworkImage(
                        imageUrl: product.image ?? "",
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          child: FlutterLogo(),
                        ),
                        errorWidget: (context, url, error) => Skeletonizer(
                            child: Container(
                          color: ColorManager.white,
                          height: 100,
                          width: 100,
                        )),
                      ),
                    ),
                  ),
                ),
                space(h: AppSize.s10),
                Text(
                  product.title ?? "",
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
                        padding: const EdgeInsets.only(left: AppPadding.p10),
                        child: Text(
                          "\$${product.discountPrice}",
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
            ),
            Positioned(
              bottom: 0,
              right: 2,
              child: RoundCorner(
                  child: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(Iconsax.box_add))),
            ),
            Positioned(
                bottom: 0,
                left: 2,
                child: Row(
                  children: List.generate(4, (index) {
                    return Icon(
                      Iconsax.star,
                      size: AppSize.s20,
                    );
                  }),
                )),
          ],
        ),
      ),
    );
  }
}
