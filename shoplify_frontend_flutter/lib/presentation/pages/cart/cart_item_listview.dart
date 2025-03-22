import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/cart_item_widget.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';

class CartItemListview extends StatelessWidget {
  const CartItemListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        switch (state.status) {
          case CartStatus.initial:
            return const SizedBox.shrink();
          case CartStatus.loading:
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return const CartItemSkeletonWidget();
              },
            );
          case CartStatus.failure:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p10),
                child: ErrorMessageWidget(
                  message: state.errorMessage,
                  retry: () {
                    context.read<CartBloc>().add(GetCartEvent());
                  },
                ),
              ),
            );
          case CartStatus.success:
            if (state.cart?.items == null || state.cart!.items!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: AppPadding.p150),
                child: EmptyWidget(
                  icon: Icon(
                    Iconsax.shop_add,
                    size: AppSize.s50,
                  ),
                  message: AppStrings.yourCartIsEmpty,
                ),
              );
            } else {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.cart?.items?.length ?? 0,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  ProductModelEntity? cartItems =
                      state.cart?.items?[index].product?.toEntity();

                  return CartItemWidget(
                    product: cartItems!,
                    index: index,
                  );
                },
              );
            }
        }
      },
    );
  }
}
