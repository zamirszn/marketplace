import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/cart/bloc/cart_bloc.dart';
import 'package:shoplify/presentation/pages/cart/remove_from_cart/bloc/remove_from_cart_bloc.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class RemoveFromCartWidget extends StatelessWidget {
  const RemoveFromCartWidget(
      {super.key,
      required this.productId,
      required this.cartItemId,
      required this.cartId});
  final String productId;
  final int? cartItemId;
  final String? cartId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoveFromCartBloc>(
      create: (context) => RemoveFromCartBloc(),
      child: BlocListener<RemoveFromCartBloc, RemoveFromCartState>(
        listener: (context, state) {
          if (state is RemoveFromCartFailure) {
            showErrorMessage(context, state.message);
          } else if (state is RemoveFromCartSuccess) {
            context
                .read<CartBloc>()
                .add(RemoveProductFromCartPageEvent(cartItemId: productId));
          }
        },
        child: BlocBuilder<RemoveFromCartBloc, RemoveFromCartState>(
          builder: (context, state) {
            if (state is RemoveFromCartLoading) {
              return Padding(
                padding: const EdgeInsets.only(right: AppPadding.p2),
                child: Transform.scale(scale: .6, child: const LoadingWidget()),
              );
            }
            return IconButton(
                onPressed: () {
                  context.read<RemoveFromCartBloc>().add(
                      RemoveProductFromCartById(
                          removeFromCartModelParams: RemoveFromCartModelParams(
                              cartId: cartId!, cartItemId: cartItemId!)));
                },
                icon: const Icon(
                  Iconsax.close_circle,
                ));
          },
        ),
      ),
    );
  }
}
