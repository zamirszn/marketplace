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
        extendBodyBehindAppBar: true,
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
                        height: AppSize.s100,
                        width: deviceWidth(context),
                        decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppSize.s20),
                              bottomRight: Radius.circular(AppSize.s20),
                            )),
                        padding: const EdgeInsets.only(
                            right: AppPadding.p12,
                            left: AppPadding.p12,
                            top: 10),
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
                                    AppStrings.productInfo,
                                    style:
                                        getRegularStyle(fontSize: FontSize.s16),
                                  ),
                                  space(h: AppSize.s4),
                                  Text(
                                    product.description ?? "",
                                    style:
                                        getLightStyle(fontSize: FontSize.s14),
                                  ),
                                  space(h: AppSize.s20),
                                  Wrap(
                                    children: [
                                      if (product.inventory != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppSize.s10),
                                          child: ColoredBox(
                                            color: product.inventory != null &&
                                                    product.inventory! >= 1
                                                ? ColorManager.green
                                                : ColorManager.red,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${product.inventory} available in stock",
                                                  style: getRegularStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s12,
                                                      font: FontConstants
                                                          .poppins),
                                                )),
                                          ),
                                        ),
                                      space(w: AppSize.s10),
                                      if (product.category?.title != null &&
                                          product.category!.title.isNotEmpty)
                                        RoundCorner(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                product.category?.title ?? "",
                                                style: getRegularStyle(
                                                    fontSize: FontSize.s12,
                                                    font:
                                                        FontConstants.poppins),
                                              )),
                                        ),
                                    ],
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
                                          Icon(Iconsax.arrow_right)
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.averageRating?.toString() ??
                                                "0",
                                            style: getRegularStyle(
                                                fontSize: FontSize.s30,
                                                font: FontConstants.ojuju),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              "/5",
                                              style: getRegularStyle(
                                                  fontSize: FontSize.s16,
                                                  font: FontConstants.ojuju),
                                            ),
                                          ),
                                        ],
                                      ),
                                      space(h: AppSize.s4),
                                      Text(
                                        "${AppStrings.basedOn} ${product.reviewsLength} ${AppStrings.reviews}",
                                        style: getLightStyle(
                                            fontSize: FontSize.s14,
                                            color: ColorManager.grey,
                                            font: FontConstants.poppins),
                                      ),
                                      space(h: AppSize.s12),
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
                                      space(h: AppSize.s8),
                                    ],
                                  ),
                                ))),
                      ),
                      space(h: AppSize.s3),
                      if (product.inventory != null && product.inventory! > 0)
                        SizedBox(
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
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  showDragHandle: true,
                                  enableDrag: true,
                                  builder: (context) => AddtoCartBottomSheet(),
                                );
                              },
                              child: Text(
                                AppStrings.addToCart,
                                style: getRegularStyle(
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s18),
                              )),
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

class AddtoCartBottomSheet extends StatelessWidget {
  const AddtoCartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
