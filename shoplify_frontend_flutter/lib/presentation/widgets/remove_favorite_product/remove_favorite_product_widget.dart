import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/favorite/bloc/favorite_bloc.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/remove_favorite_product/bloc/remove_favorite_bloc.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class RemoveFavoriteProductWidget extends StatelessWidget {
  const RemoveFavoriteProductWidget({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RemoveFavoriteBloc(),
        ),
      ],
      child: BlocListener<RemoveFavoriteBloc, RemoveFavoriteState>(
        listener: (ctx, state) {
          if (state is RemoveFromFavoriteFailure) {
            showErrorMessage(ctx, state.message);
          } else if (state is RemoveFromFavoriteSuccess) {
            context
                .read<FavoriteBloc>()
                .add(RemoveFromFavoritePageEvent(productId: productId));
          }
        },
        child: BlocBuilder<RemoveFavoriteBloc, RemoveFavoriteState>(
          builder: (context, state) {
            if (state is RemoveFromFavoriteLoading) {
              return SizedBox(
                  height: AppSize.s40,
                  child:
                      Transform.scale(scale: .7, child: const LoadingWidget()));
            }

            return IconButton(
                onPressed: () {
                  context
                      .read<RemoveFavoriteBloc>()
                      .add(RemoveFromFavoriteByIdEvent(productId: productId));
                },
                icon: Icon(
                  Iconsax.save_remove,
                  color: ColorManager.white,
                ));
          },
        ),
      ),
    );
  }
}
