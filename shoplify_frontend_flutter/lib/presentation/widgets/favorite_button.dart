import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        // Get favorite status from bloc state instead of passing it as parameter
        final isFavorite = state.isFavorite(product.id ?? '');

        final isLoading = state.isProductLoading(product.id!);
        return isLoading
            ? Transform.scale(scale: .6, child: const LoadingWidget())
            : IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (product.id != null) {
                          context.read<FavoriteBloc>().add(
                                ToggleFavoriteEvent(
                                  product: product,
                                  isCurrentlyFavorited: isFavorite,
                                ),
                              );
                        }
                      },
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(
                  isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  color: isFavorite ? ColorManager.red : null,
                ),
              );
      },
    );
  }
}
