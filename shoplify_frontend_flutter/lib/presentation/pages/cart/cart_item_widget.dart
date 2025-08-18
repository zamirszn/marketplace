import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/remove_from_cart/remove_from_cart_widget.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.product, required this.index});
  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cartState = context.read<CartBloc>().state;
    return GestureDetector(
      onTap: () {
        context
            .read<ProductDetailsBloc>()
            .add(SetProductDetailsEvent(product: product));
        goPush(
          context,
          Routes.productDetailsPage,
          extra: {'heroTag': '${product.id}_cart'},
        );
      },
      child: Hero(
        tag: '${product.id}_cart',
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
                  imageUrl: product.images.isNotEmpty
                      ? product.images.first.image!
                      : "",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(context, fontSize: FontSize.s17),
                    ),
                    space(h: AppSize.s20),
                    Text(
                      "\$${roundToTwoDecimalPlaces(product.price)}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: FontSize.s18,
                          fontWeight: FontWeightManager.bold,
                          fontFamily: FontConstants.ojuju),
                    ),
                    if (product.oldPrice != null)
                      Text(
                        "\$${roundToTwoDecimalPlaces(product.oldPrice)}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeightManager.light,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: FontConstants.ojuju),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RemoveFromCartWidget(
                      productId: product.id!,
                      cartItemId: cartState.cart?.items?[index].id,
                      cartId: cartState.cart?.id!,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
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
                                    fontSize: FontSize.s16),
                              ),
                            );
                          },
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.add_circle5,
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
