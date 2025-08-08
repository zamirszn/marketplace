import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/bloc/add_to_cart_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddtoCartBottomSheet extends StatelessWidget {
  const AddtoCartBottomSheet(
      {super.key, required this.product, this.bottomSheetCallback});
  final Product? product;

  /// use this callback to get the latest product data from the server
  /// when the a product is added to cart and `AddtoCartBottomSheet` is closed
  final VoidCallback? bottomSheetCallback;

  @override
  Widget build(BuildContext context) {
    AddToCartBottomsheetBloc cartBottomsheetBloc =
        context.read<AddToCartBottomsheetBloc>();

    if (product != null) {
      cartBottomsheetBloc.add(SetCartItem(product: product!));
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        cartBottomsheetBloc.add(ResetCartItemCountEvent());
      },
      child: BlocListener<ProductBloc, ProductState>(
        listener: (ctx, productState) {
          if (productState is AddToFavoriteFailure) {
            showErrorMessage(context, productState.message);
          } else if (productState is ToggleFavoriteAddSuccess) {
            if (productState.message != null) {
              showMessage(context, productState.message!);
            }
            // if the server returns a product object (product was favorited)
            // add the object to favorite product page
            // server returns null if the

            if (product != null) {
              ctx
                  .read<FavoriteBloc>()
                  .add(AddToFavoritePageEvent(product: productState.product!));
            }
          } else if (productState is ToggleFavoriteRemoveSuccess) {
            if (productState.message != null) {
              showMessage(context, productState.message!);
            }
          }
        },
        child:
            BlocListener<AddToCartBottomsheetBloc, AddToCartBottomsheetState>(
          listener: (context, state) {
            if (state.status == AddToCartStatus.failure) {
              if (state.errorMessage != null) {
                showErrorMessage(context, state.errorMessage!);
              }
            } else if (state.status == AddToCartStatus.success) {
              if (state.cartItemToAdd != null) {
                context.read<CartBloc>().add(AddProductToCartPageEvent(
                    cartItem: state.cartItemToAdd!,
                    quantityToAdd: state.itemCount));
              }
              showMessage(
                  context, "${product?.name} ${AppStrings.addedToCart}");
              if (bottomSheetCallback != null) {
                bottomSheetCallback!();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            child: Text(product?.name ?? "",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: getRegularStyle(context,
                                    font: FontConstants.ojuju,
                                    fontSize: FontSize.s18)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.s50,
                        width: AppSize.s50,
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            bool currentFavoritedState =
                                product?.isFavorite ?? false;

                            if (state is AddToFavoriteLoading) {
                              return Transform.scale(
                                  scale: .5, child: const LoadingWidget());
                            }

                            if (state is ToggleFavoriteAddSuccess &&
                                state.isFavorited == true) {
                              return IconButton(
                                  onPressed: () {
                                    if (product?.id != null) {
                                      context.read<ProductBloc>().add(
                                            ToggleFavoriteEvent(
                                              productId: product!.id!,
                                              isCurrentlyFavorited:
                                                  currentFavoritedState,
                                            ),
                                          );
                                    }
                                  },
                                  icon: Icon(
                                    Iconsax.heart5,
                                    color: ColorManager.blue,
                                    size: AppSize.s28,
                                  ));
                            } else {
                              return IconButton(
                                  onPressed: () {
                                    if (product?.id != null) {
                                      context.read<ProductBloc>().add(
                                            ToggleFavoriteEvent(
                                              productId: product!.id!,
                                              isCurrentlyFavorited:
                                                  currentFavoritedState,
                                            ),
                                          );
                                    }
                                  },
                                  icon: Icon(
                                    Iconsax.heart,
                                    color: ColorManager.blue,
                                    size: AppSize.s28,
                                  ));
                            }
                          },
                        ),
                      )
                    ],
                  ),

                  space(h: AppSize.s20),
                  // image
                  RoundCorner(
                    child: product?.images == null
                        ? const SizedBox()
                        : CachedNetworkImage(
                            imageUrl: product!.images.isNotEmpty
                                ? product!.images.first.image!
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
                            style: getRegularStyle(
                              context,
                            ),
                          ),
                          space(h: AppSize.s10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: AppSize.s70,
                                child: Text(
                                  "\$${roundToTwoDecimalPlaces(product?.price) ?? ""}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(context,
                                      fontSize: FontSize.s18,
                                      font: FontConstants.ojuju),
                                ),
                              ),
                              if (product?.oldPrice != null &&
                                  product?.oldPrice != product?.price)
                                Text(
                                  "${roundToTwoDecimalPlaces(product?.oldPrice)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      decoration: product?.discount != null &&
                                              product?.discount == true
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontSize: FontSize.s14,
                                      fontFamily: FontConstants.ojuju),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              AppStrings.quantity,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                context,
                              ),
                            ),
                          ),
                          space(h: AppSize.s10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<AddToCartBottomsheetBloc>()
                                      .add(DecreaseCartItemCountEvent());
                                },
                                child: const Icon(
                                  Iconsax.minus_cirlce,
                                  size: AppSize.s28,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s16),
                                child: BlocBuilder<AddToCartBottomsheetBloc,
                                    AddToCartBottomsheetState>(
                                  builder: (context, state) {
                                    return Text(
                                      // amount should be more than whats in inventory
                                      "${state.itemCount}",
                                      textAlign: TextAlign.center,
                                      style: getSemiBoldStyle(context,
                                          font: FontConstants.ojuju,
                                          fontSize: FontSize.s16),
                                    );
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (product?.inventory != null) {
                                    if (product!.inventory! <=
                                        cartBottomsheetBloc.state.itemCount) {
                                      showErrorMessage(context,
                                          AppStrings.inventoryLimitReached);
                                    } else {
                                      context
                                          .read<AddToCartBottomsheetBloc>()
                                          .add(IncreaseCartItemCountEvent());
                                    }
                                  }
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
                  if ((product?.inventory ?? 0) > 0)
                    BlocBuilder<AddToCartBottomsheetBloc,
                        AddToCartBottomsheetState>(
                      builder: (context, state) {
                        if (state.status == AddToCartStatus.loading) {
                          return SizedBox(
                              height: AppSize.s60,
                              width: double.infinity,
                              child: ButtonLoadingWidget(
                                backgroundColor: ColorManager.grey,
                              ));
                        } else {
                          return SizedBox(
                            height: AppSize.s60,
                            width: double.infinity,
                            child: ElevatedButton(
                              
                                onPressed: () {
                                  context
                                      .read<AddToCartBottomsheetBloc>()
                                      .add(AddItemToCartEvent());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        getTotalPrice(
                                            product?.price, state.itemCount),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: getRegularStyle(context,
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
                                        style: getRegularStyle(context,
                                            font: FontConstants.ojuju,
                                            fontSize: FontSize.s18),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }
                      },
                    ),

                  space(h: AppSize.s6)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTotalPrice(num? price, int itemCount) {
    if (price != null) {
      num total = price * itemCount;
      return "\$ ${total.toStringAsFixed(2)}";
    } else {
      return "";
    }
  }
}
