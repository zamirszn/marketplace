import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.product});
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s100,
      margin: const EdgeInsets.only(
          left: AppMargin.m8,
          top: AppMargin.m12,
          bottom: AppMargin.m12,
          right: AppMargin.m8),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(AppSize.s20)),
      padding: const EdgeInsets.only(
          left: AppPadding.p12, top: AppPadding.p12, bottom: AppPadding.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundCorner(
            child: CachedNetworkImage(
              imageUrl:
                  product.images.isNotEmpty ? product.images.first.image! : "",
              height: 70,
              width: 65,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                child: FlutterLogo(),
              ),
              errorWidget: (context, url, error) => Skeletonizer(
                  child: Container(
                color: ColorManager.white,
                height: 70,
                width: 65,
              )),
            ),
          ),
          SizedBox(
            width: deviceWidth(context) - AppSize.s200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(fontSize: FontSize.s17),
                ),
                Text(
                  "\$${product.price}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontConstants.ojuju),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.minus_cirlce,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s4),
                child: Text(
                  "1",
                  style: getRegularStyle(
                      font: FontConstants.ojuju, fontSize: FontSize.s16),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.add_circle5,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
