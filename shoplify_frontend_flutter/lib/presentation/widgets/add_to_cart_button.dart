import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/widgets/add_to_cart_bottomsheet/bloc/add_to_cart_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({
    super.key,
    required this.product,
    this.callback,
  });

  final Product product;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToCartBottomsheetBloc, AddToCartBottomsheetState>(
      listener: (context, state) {
        if (state.selectedProductId == product.id &&
            state.status == AddToCartStatus.success) {
          if (state.cartItemToAdd != null) {
            context.read<CartBloc>().add(AddProductToCartPageEvent(
                cartItem: state.cartItemToAdd!, quantityToAdd: 1));
          }
          showMessage(context, "${product.name} ${AppStrings.addedToCart}");
        } else if (state.selectedProductId == product.id &&
            state.status == AddToCartStatus.failure) {
          if (state.errorMessage != null) {
            showErrorMessage(context, state.errorMessage!);
          }
        }
      },
      child: BlocBuilder<AddToCartBottomsheetBloc, AddToCartBottomsheetState>(
        builder: (context, state) {
          if (state.status == AddToCartStatus.loading &&
              state.selectedProductId == product.id) {
            return Transform.scale(scale: .5, child: const LoadingWidget());
          } else {
            return IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (product.inventory != null && product.inventory! > 0) {
                    context.read<AddToCartBottomsheetBloc>().add(
                          SetCartItem(
                            product: product,
                          ),
                        );

                    context
                        .read<AddToCartBottomsheetBloc>()
                        .add(AddItemToCartEvent());
                  } else {
                    showErrorMessage(context, AppStrings.outOfStock);
                  }
                },
                icon: const Icon(
                  Iconsax.shop_add,
                ));
          }
        },
      ),
    );
  }
}
