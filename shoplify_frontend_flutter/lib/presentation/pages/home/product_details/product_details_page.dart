import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/add_to_cart_bottomsheet.dart';
import 'package:shoplify/presentation/widgets/coverflow_carousel.dart';
import 'package:shoplify/presentation/widgets/favorite_button.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/refresh_widget.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    this.heroTag,
  });
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.product,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              context,
              font: FontConstants.ojuju,
              fontSize: AppSize.s24,
            ),
          ),
          forceMaterialTransparency: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppPadding.p10),
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  return FavoriteButton(
                    product: state.selectedProduct!,
                  );
                },
              ),
            ),
          ],
          leading: const Padding(
            padding: EdgeInsets.all(AppPadding.p10),
            child: GoBackButton(),
          ),
        ),
        body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            return Hero(
              tag: heroTag ?? "0",
              child: SizedBox(
                height: deviceHeight(context),
                width: deviceWidth(context),
                child: RefreshWidget(
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
                            space(h: AppSize.s3),
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppPadding.p20),
                                  child: Transform.scale(
                                    scale: 1.1,
                                    child: CoverFlowCarousel(
                                        productImages:
                                            state.selectedProduct?.images ??
                                                []),
                                  ),
                                )),
                            space(h: AppSize.s3),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.s20),
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
                                        Expanded(
                                          child: Text(
                                            state.selectedProduct?.name ?? "",
                                            style: getMediumStyle(context,
                                                fontSize: FontSize.s20,
                                                font: FontConstants.ojuju),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${AppStrings.price}: \$${roundToTwoDecimalPlaces(state.selectedProduct?.price) ?? ""}",
                                            textAlign: TextAlign.end,
                                            style: getSemiBoldStyle(context,
                                                fontSize: FontSize.s20,
                                                font: FontConstants.ojuju),
                                          ),
                                        ),
                                      ],
                                    ),
                                    space(h: AppSize.s28),
                                    Text(
                                      AppStrings.productInfo,
                                      style: getRegularStyle(context,
                                          fontSize: FontSize.s16),
                                    ),
                                    space(h: AppSize.s4),
                                    ReadMoreText(
                                        text: state
                                                .selectedProduct?.description ??
                                            ""),
                                    space(h: AppSize.s20),
                                    Wrap(
                                      children: [
                                        if (state.selectedProduct?.inventory !=
                                            null)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppSize.s10),
                                            child: ColoredBox(
                                              color: state.selectedProduct!
                                                              .inventory !=
                                                          null &&
                                                      state.selectedProduct!
                                                              .inventory! >=
                                                          1
                                                  ? colorScheme
                                                      .secondaryContainer
                                                  : colorScheme.error,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${state.selectedProduct?.inventory} available in stock",
                                                    style: getRegularStyle(
                                                        context,
                                                        fontSize: FontSize.s12,
                                                        font: FontConstants
                                                            .poppins),
                                                  )),
                                            ),
                                          ),
                                        space(w: AppSize.s10),
                                        if (state.selectedProduct?.category
                                                ?.name !=
                                            null)
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<SearchBloc>()
                                                  .add(ResetSearchEvent());
                                              context.read<SearchBloc>().add(
                                                  SearchProductEvent(
                                                      useFilterParams: true,
                                                      searchParamsModel:
                                                          SearchParamsModel(
                                                              category: state
                                                                  .selectedProduct
                                                                  ?.category
                                                                  ?.name)));

                                              goPush(
                                                context,
                                                Routes.searchPage,
                                              );
                                            },
                                            child: RoundCorner(
                                              color:
                                                  colorScheme.primaryContainer,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    state.selectedProduct
                                                            ?.category?.name ??
                                                        "",
                                                    style: getRegularStyle(
                                                        context,
                                                        fontSize: FontSize.s12,
                                                        font: FontConstants
                                                            .poppins),
                                                  )),
                                            ),
                                          ),
                                      ],
                                    ),
                                    space(h: AppSize.s10),
                                  ],
                                ),
                              ),
                            ),
                            space(h: AppSize.s3),
                            GestureDetector(
                              onTap: () {
                                goPush(
                                  context,
                                  Routes.reviewPage,
                                );
                              },
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s20),
                                  child: ColoredBox(
                                      color:
                                          colorScheme.onSecondary.withAlpha(50),
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
                                                  style: getMediumStyle(context,
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
                                                      context,
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
                                                        context,
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
                                              style: getLightStyle(context,
                                                  fontSize: FontSize.s14,
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
                                              product: state.selectedProduct,
                                              bottomSheetCallback: () {
                                                // get the product latest data from the server

                                                if (state.selectedProduct?.id !=
                                                    null) {
                                                  context
                                                      .read<
                                                          ProductDetailsBloc>()
                                                      .add(RefreshProductDetailsEvent(
                                                          productId: state
                                                              .selectedProduct!
                                                              .id!));
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings.addToCart,
                                      style: getRegularStyle(context,
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
