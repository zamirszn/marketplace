import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/cart_model.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/remove_from_cart/remove_from_cart_widget.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {super.key, required this.index, required this.cartItem});
  final CartItem cartItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cartBloc = context.read<CartBloc>();
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.quantityOperationStatus == QuantityOperationStatus.failure &&
            state.operatingItemId == cartItem.id) {
          if (state.quantityOperationError != null) {
            showErrorMessage(context, state.quantityOperationError!);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          if (cartItem.product != null) {
            context
                .read<ProductDetailsBloc>()
                .add(SetProductDetailsEvent(product: cartItem.product!));
            goPush(
              context,
              Routes.productDetailsPage,
              extra: {'heroTag': '${cartItem.product?.id}_cart'},
            );
          }
        },
        child: Hero(
          tag: '${cartItem.product?.id}_cart',
          child: Container(
            height: AppSize.s120,
            margin: const EdgeInsets.only(
                left: AppMargin.m8,
                top: AppMargin.m6,
                bottom: AppMargin.m6,
                right: AppMargin.m8),
            decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(AppSize.s20)),
            padding: const EdgeInsets.only(
                left: AppPadding.p12,
                top: AppPadding.p12,
                bottom: AppPadding.p12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundCorner(
                  child: CachedNetworkImage(
                    imageUrl: cartItem.product?.images.first.image ?? "",
                    height: AppSize.s100,
                    width: AppSize.s100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Skeletonizer(
                      child: Container(
                        color: colorScheme.secondary,
                        height: AppSize.s100,
                        width: AppSize.s100,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.error,
                      height: AppSize.s100,
                      width: AppSize.s100,
                    ),
                  ),
                ),
                space(w: AppSize.s10),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.product?.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(context, fontSize: FontSize.s17)
                            .copyWith(decoration: TextDecoration.none),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          StarRatingWidget(
                              rating: cartItem.product?.averageRating ?? 0),
                        ],
                      ),
                      if (cartItem.product?.discountedPrice != null)
                        Text(
                          "\$${roundToTwoDecimalPlaces(cartItem.product?.price)}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              decoration:
                                  cartItem.product?.discountedPrice != null
                                      ? TextDecoration.lineThrough
                                      : null,
                              fontSize: FontSize.s12,
                              fontFamily: FontConstants.ojuju),
                        ),
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: AppSize.s90),
                        child: Text(
                          cartItem.product?.discountedPrice != null
                              ? "\$${roundToTwoDecimalPlaces(cartItem.product?.discountedPrice)}"
                              : "\$${roundToTwoDecimalPlaces(cartItem.product?.price)}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontConstants.ojuju),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.quantityOperationStatus ==
                            QuantityOperationStatus.updating &&
                        state.operatingItemId == cartItem.id) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p5),
                        child: Transform.scale(
                            scale: .6, child: const LoadingWidget()),
                      ));
                    }
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RemoveFromCartWidget(
                            productId: cartItem.product!.id!,
                            cartItemId: cartBloc.state.cart?.items?[index].id,
                            cartId: cartBloc.state.cart?.id!,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    cartBloc.add(DecreaseCartItemQuantityEvent(
                                        product: cartItem.product!));
                                  },
                                  icon: const Icon(
                                    Iconsax.minus_cirlce,
                                  )),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.s4),
                                    child: Text(
                                      "${state.cart?.items?[index].quantity}",
                                      style: getRegularStyle(context,
                                              font: FontConstants.ojuju,
                                              fontSize: FontSize.s16)
                                          .copyWith(
                                              decoration: TextDecoration.none),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    cartBloc.add(IncreaseCartItemQuantityEvent(
                                        product: cartItem.product!));
                                  },
                                  icon: const Icon(
                                    Iconsax.add_circle5,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
