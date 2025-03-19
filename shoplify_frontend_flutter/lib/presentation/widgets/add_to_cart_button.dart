import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/add_to_cart_params_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({
    super.key,
    required this.product,
  });

  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is AddToCartSuccess) {
            if (state.cartItemToAdd != null) {
              context.read<CartBloc>().add(AddProductToCartPageEvent(
                  cartItem: state.cartItemToAdd!, quantityToAdd: 1));
            }
            showMessage(context, "${product.name} ${AppStrings.addedToCart}");
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is AddToCartLoading) {
              return Transform.scale(scale: .5, child: const LoadingWidget());
            } else {
              return IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: ColorManager.white,
                  onPressed: () {
                    if (product.inventory != null && product.inventory! > 0) {
                      context.read<ProductBloc>().add(AddToCartEvent(
                          params: AddToCartParamsModel(
                              productId: product.id!, quantity: 1)));
                    } else {
                      showErrorMessage(context, AppStrings.outOfStock);
                    }
                  },
                  icon: Icon(
                    Iconsax.shop_add,
                    color: ColorManager.white,
                  ));
            }
          },
        ),
      ),
    );
  }
}
