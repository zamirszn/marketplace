import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/routes_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/widgets/back_button.dart';
import 'package:marketplace/presentation/widgets/image_carousel.dart';
import 'package:marketplace/presentation/widgets/star_rating_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    this.heroTag,
  });
  final ProductModelEntity product;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        body: Hero(
          tag: heroTag ?? "0",
          child: SizedBox(
            height: deviceHeight(context),
            width: deviceWidth(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        height: AppSize.s70,
                        width: deviceWidth(context),
                        decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppSize.s20),
                              bottomRight: Radius.circular(AppSize.s20),
                            )),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: AppSize.s40,
                                width: AppSize.s40,
                                child: const GoBackButton()),
                            Text(
                              AppStrings.product,
                              style: getRegularStyle(
                                  font: FontConstants.ojuju,
                                  fontSize: FontSize.s20),
                            ),
                            SizedBox(
                              height: AppSize.s40,
                              width: AppSize.s40,
                              child: RoundCorner(
                                child: Center(
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Badge(
                                          label: const Text("3"),
                                          backgroundColor:
                                              ColorManager.secondaryDark,
                                          textColor: ColorManager.white,
                                          textStyle: getRegularStyle(
                                              font: FontConstants.ojuju),
                                          child: const Icon(
                                              Iconsax.shopping_cart))),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      space(h: AppSize.s3),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                          child: ColoredBox(
                              color: ColorManager.primary,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppPadding.p20),
                                child: CoverFlowCarouselPage(
                                    productImages: product.images),
                              ))),
                      space(h: AppSize.s3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        child: ColoredBox(
                            color: ColorManager.primary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p10,
                                  horizontal: AppPadding.p10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  space(h: AppSize.s10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(
                                            width: deviceWidth(context) / 2),
                                        child: Text(
                                          product.name ?? "",
                                          style: getRegularStyle(
                                            fontSize: FontSize.s16,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Price: \$${product.price?.toString() ?? ""}",
                                          textAlign: TextAlign.end,
                                          style: getSemiBoldStyle(
                                              fontSize: FontSize.s16,
                                              font: FontConstants.ojuju),
                                        ),
                                      ),
                                    ],
                                  ),
                                  space(h: AppSize.s28),
                                  Text(
                                    product.description ?? "",
                                    style:
                                        getLightStyle(fontSize: FontSize.s14),
                                  ),
                                  space(h: AppSize.s20),
                                  RoundCorner(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          product.category?.title ?? "",
                                          style: getRegularStyle(
                                              fontSize: 10,
                                              font: FontConstants.poppins),
                                        )),
                                  ),
                                  space(h: AppSize.s10),
                                ],
                              ),
                            )),
                      ),
                      space(h: AppSize.s3),
                      GestureDetector(
                        onTap: () {
                          goPush(context, Routes.productReviewPage,
                              extra: product);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.s20),
                            child: ColoredBox(
                                color: ColorManager.primary,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p10,
                                      horizontal: AppPadding.p10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppStrings.reviews,
                                            style: getMediumStyle(
                                                fontSize: FontSize.s14),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                goPush(context,
                                                    Routes.productReviewPage,
                                                    extra: product.id);
                                              },
                                              icon: Icon(Iconsax.arrow_right))
                                        ],
                                      ),
                                      Text(
                                        product.averageRating?.toString() ??
                                            "0",
                                        style: getRegularStyle(
                                            fontSize: FontSize.s20,
                                            font: FontConstants.ojuju),
                                      ),
                                      space(h: AppSize.s10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 1.4,
                                            child: StarRating(
                                                rating:
                                                    product.averageRating ?? 0),
                                          ),
                                        ],
                                      ),
                                      space(h: AppSize.s6),
                                    ],
                                  ),
                                ))),
                      ),
                      space(h: AppSize.s3),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: AppSize.s70,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20)),
                                shadowColor: Colors.transparent,
                                foregroundColor: ColorManager.black,
                                backgroundColor: ColorManager.primaryDark,
                              ),
                              onPressed: () {},
                              child: Text(
                                AppStrings.addToCart,
                                style: getRegularStyle(
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s18),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
