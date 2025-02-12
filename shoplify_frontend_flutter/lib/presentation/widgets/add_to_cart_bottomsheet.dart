import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddtoCartBottomSheet extends StatelessWidget {
  const AddtoCartBottomSheet({super.key, required this.product});
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (BuildContext context) => ProductBloc(),
        ),
      ],
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
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: BlocListener<ProductBloc, ProductState>(
                      listener: (ctx, state) {
                        if (state is AddToFavoriteFailure) {
                          showErrorMessage(context, state.message);
                        } else if (state is ToggleFavoriteSuccess &&
                            state.message!.isNotEmpty) {
                          showMessage(context, state.message!);
                        }
                      },
                      child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          print("is liked ${product.isFavorite} - $state");
                          bool currentFavoritedState =
                              product.isFavorite ?? false;

                          if (state is ToggleFavoriteSuccess &&
                              state.productId == product.id) {
                            currentFavoritedState = state.isFavorited;
                          }

                          if (state is AddToFavoriteLoading) {
                            return Transform.scale(
                                scale: .5, child: const LoadingWidget());
                          }

                          if (state is ToggleFavoriteSuccess &&
                              state.isFavorited == true) {
                            return IconButton(
                                onPressed: () {
                                  context.read<ProductBloc>().add(
                                        ToggleFavoriteEvent(
                                          productId: product.id!,
                                          isCurrentlyFavorited:
                                              currentFavoritedState,
                                        ),
                                      );
                                },
                                icon: Icon(
                                  Iconsax.heart5,
                                  color: ColorManager.secondary,
                                  size: AppSize.s28,
                                ));
                          } else {
                            return IconButton(
                                onPressed: () {
                                  context.read<ProductBloc>().add(
                                        ToggleFavoriteEvent(
                                          productId: product.id!,
                                          isCurrentlyFavorited:
                                              currentFavoritedState,
                                        ),
                                      );
                                },
                                icon: Icon(
                                  Iconsax.heart,
                                  color: ColorManager.secondary,
                                  size: AppSize.s28,
                                ));
                          }
                        },
                      ),
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
                          if (product.oldPrice != null &&
                              product.oldPrice != product.price)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: AppPadding.p10),
                              child: Text(
                                "\$${product.oldPrice}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    decoration: product.discount != null &&
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
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              return Padding(
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
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              context
                                  .read<CartBloc>()
                                  .add(IncreaseSingleCartItemCountEvent());
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
                          borderRadius: BorderRadius.circular(AppSize.s20)),
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
  }
}
