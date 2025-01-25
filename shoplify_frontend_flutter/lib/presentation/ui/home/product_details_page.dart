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
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/image_carousel.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
            child: RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p2),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          height: AppSize.s100,
                          width: deviceWidth(context),
                          decoration: BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: const BorderRadius.only(
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
                              const SizedBox(
                                  height: AppSize.s40,
                                  width: AppSize.s40,
                                  child: GoBackButton()),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                      style: getRegularStyle(
                                          fontSize: FontSize.s16),
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
                                              color: product.inventory !=
                                                          null &&
                                                      product.inventory! >= 1
                                                  ? ColorManager.green
                                                  : ColorManager.red,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${product.inventory} available in stock",
                                                    style: getRegularStyle(
                                                        color:
                                                            ColorManager.white,
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
                                                      font: FontConstants
                                                          .poppins),
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
                                            const Icon(Iconsax.arrow_right)
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              product.averageRating
                                                      ?.toString() ??
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
                                              child: StarRatingWidget(
                                                  rating:
                                                      product.averageRating ??
                                                          0),
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
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    builder: (context) => AddtoCartBottomSheet(
                                      product: product,
                                    ),
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
          ),
        ));
  }
}

class AddtoCartBottomSheet extends StatelessWidget {
  const AddtoCartBottomSheet({super.key, required this.product});
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SizedBox(
            height: deviceHeight(context) * .81,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const GoBackButton(
                          padding: EdgeInsets.all(AppPadding.p8),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p20),
                            child: Center(
                              child: Text(product.name ?? "",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: getRegularStyle(
                                      font: FontConstants.ojuju,
                                      fontSize: FontSize.s18)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.heart,
                          ),
                        )
                      ],
                    ),

                    space(h: AppSize.s20),
                    // image
                    RoundCorner(
                      child: CachedNetworkImage(
                        imageUrl: product.images.isNotEmpty
                            ? product.images.first.image!
                            : "",
                        height: 310,
                        width: 310,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          child: Container(
                            color: ColorManager.white,
                            height: 310,
                            width: 310,
                          ),
                        ),
                        errorWidget: (context, url, error) => Skeletonizer(
                            child: Container(
                          color: ColorManager.white,
                          height: 310,
                          width: 310,
                        )),
                      ),
                    ),
                    space(h: AppSize.s20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.unitPrice,
                              style: getRegularStyle(),
                            ),
                            space(h: AppSize.s10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${product.price?.toString() ?? ""}",
                                  textAlign: TextAlign.end,
                                  style: getBoldStyle(
                                      fontSize: FontSize.s18,
                                      font: FontConstants.ojuju),
                                ),
                                if (product.oldPrice != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppPadding.p10),
                                    child: Text(
                                      "\$${product.oldPrice}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decoration:
                                              product.discount != null &&
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.quantity,
                              style: getRegularStyle(),
                            ),
                            space(h: AppSize.s10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // context
                                    //     .read<CartBloc>()
                                    //     .add(());
                                  },
                                  child: const Icon(
                                    Iconsax.minus_cirlce,
                                    size: AppSize.s28,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.s16),
                                  child: Text(
                                    // amount should be more than whats in inventory
                                    "${state.singleItem?.quantity ?? '1'} ",
                                    textAlign: TextAlign.center,
                                    style: getSemiBoldStyle(
                                        font: FontConstants.ojuju,
                                        fontSize: FontSize.s16),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                        IncreaseSingleCartItemCountEvent());
                                  },
                                  child: const Icon(
                                    Iconsax.add_circle5,
                                    size: AppSize.s28,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    space(h: AppSize.s36),
                    // add to cart
                    if (product.inventory != null && product.inventory! > 0)
                      SizedBox(
                        height: AppSize.s60,
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
                          child:
                              // Transform.scale(
                              //           scale: .85, child: const LoadingWidget())

                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "\$${product.price?.toString() ?? ""}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: getRegularStyle(
                                      font: FontConstants.ojuju,
                                      fontSize: FontSize.s18),
                                ),
                              ),
                              const VerticalDivider(),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  AppStrings.addToCart,
                                  textAlign: TextAlign.center,
                                  style: getRegularStyle(
                                      font: FontConstants.ojuju,
                                      fontSize: FontSize.s18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    space(h: AppSize.s6)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
