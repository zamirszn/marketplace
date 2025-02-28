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
import 'package:shoplify/presentation/ui/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/add_to_cart_bottomsheet.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/coverflow_carousel.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    this.heroTag,
  });
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            return Hero(
              tag: heroTag ?? "0",
              child: SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductDetailsBloc>().add(
                        RefreshProductDetailsEvent(
                            productId: state.selectedProduct!.id!));
                  },
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
                                  color: ColorManager.lightGrey,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(AppSize.s20),
                                    bottomRight: Radius.circular(AppSize.s20),
                                  )),
                              padding: const EdgeInsets.only(
                                  right: AppPadding.p12,
                                  left: AppPadding.p12,
                                  top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                    ColorManager.darkBlue,
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
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20),
                                child: ColoredBox(
                                    color: ColorManager.lightGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p20),
                                      child: CoverFlowCarousel(
                                          productImages:
                                              state.selectedProduct?.images ??
                                                  []),
                                    ))),
                            space(h: AppSize.s3),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.s20),
                              child: ColoredBox(
                                  color: ColorManager.lightGrey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppPadding.p10,
                                        horizontal: AppPadding.p10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        space(h: AppSize.s10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      width:
                                                          deviceWidth(context) /
                                                              2),
                                              child: Text(
                                                state.selectedProduct?.name ??
                                                    "",
                                                style: getRegularStyle(
                                                  fontSize: FontSize.s16,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Price: \$${state.selectedProduct?.price?.toString() ?? ""}",
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
                                          state.selectedProduct?.description ??
                                              "",
                                          style: getLightStyle(
                                              fontSize: FontSize.s14),
                                        ),
                                        space(h: AppSize.s20),
                                        Wrap(
                                          children: [
                                            if (state.selectedProduct
                                                    ?.inventory !=
                                                null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.s10),
                                                child: ColoredBox(
                                                  color: state.selectedProduct!
                                                                  .inventory !=
                                                              null &&
                                                          state.selectedProduct!
                                                                  .inventory! >=
                                                              1
                                                      ? ColorManager.green
                                                      : ColorManager.red,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${state.selectedProduct?.inventory} available in stock",
                                                        style: getRegularStyle(
                                                            color: ColorManager
                                                                .white,
                                                            fontSize:
                                                                FontSize.s12,
                                                            font: FontConstants
                                                                .poppins),
                                                      )),
                                                ),
                                              ),
                                            space(w: AppSize.s10),
                                            if (state.selectedProduct?.category
                                                        ?.title !=
                                                    null &&
                                                state.selectedProduct!.category!
                                                    .title.isNotEmpty)
                                              RoundCorner(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      state
                                                              .selectedProduct
                                                              ?.category
                                                              ?.title ??
                                                          "",
                                                      style: getRegularStyle(
                                                          fontSize:
                                                              FontSize.s12,
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
                                    extra: state.selectedProduct);
                              },
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s20),
                                  child: ColoredBox(
                                      color: ColorManager.lightGrey,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  state.selectedProduct
                                                          ?.averageRating
                                                          ?.toString() ??
                                                      "0",
                                                  style: getRegularStyle(
                                                      fontSize: FontSize.s30,
                                                      font:
                                                          FontConstants.ojuju),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Text(
                                                    "/5",
                                                    style: getRegularStyle(
                                                        fontSize: FontSize.s16,
                                                        font: FontConstants
                                                            .ojuju),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            space(h: AppSize.s4),
                                            Text(
                                              "${AppStrings.basedOn} ${state.selectedProduct?.reviewsLength} ${AppStrings.reviews}",
                                              style: getLightStyle(
                                                  fontSize: FontSize.s14,
                                                  color: ColorManager.lightGrey,
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
                                                      rating: state
                                                              .selectedProduct
                                                              ?.averageRating ??
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
                            if (state.selectedProduct!.inventory != null &&
                                state.selectedProduct!.inventory! > 0)
                              SizedBox(
                                height: AppSize.s70,
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSize.s20)),
                                      shadowColor: Colors.transparent,
                                      foregroundColor: ColorManager.black,
                                      backgroundColor: ColorManager.grey,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        enableDrag: true,
                                        builder: (context) => SizedBox(
                                          height: deviceHeight(context) * .81,
                                          // using a scaffold here, flutter bug does not
                                          // let snackbar show at the top of modal bottom sheet
                                          // using a snackbar is the only fix for now
                                          child: Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: AddtoCartBottomSheet(
                                              product: state.selectedProduct!,
                                              bottomSheetCallback: () {
                                                // get the product latest data from the server
                                                context
                                                    .read<ProductDetailsBloc>()
                                                    .add(RefreshProductDetailsEvent(
                                                        productId: state
                                                            .selectedProduct!
                                                            .id!));
                                              },
                                            ),
                                          ),
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
            );
          },
        ));
  }
}
