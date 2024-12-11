import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/ui/cart/cart_item_widget.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class CartItemListview extends StatelessWidget {
  const CartItemListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is CreateorGetCartLoading) {
          return const Center(
            child: LoadingWidget(),
          );
        } else if (state is CreateorGetCartFailure) {
          return Center(
            child: RetryButton(
              message: state.message,
              retry: () {
                context.read<ProductBloc>().add(CreateorGetCartEvent());
              },
            ),
          );
        } else if (state is CreateorGetCartSuccess) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.cart.items?.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              ProductModelEntity? cartItems =
                  state.cart.items?[index].product!.toEntity();

              return CartItemWidget(
                product: cartItems!,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
