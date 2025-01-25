import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/add_to_cart_params_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/interactive_3d_effect.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';
import 'package:shoplify/presentation/widgets/star_rating/star_rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.product,
  });
  final ProductModelEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goPush(
          context,
          Routes.productDetailsPage,
          extra: {'product': product, 'heroTag': '${product.id}_all'},
        );
      },
      child: Hero(
        tag: '${product.id}_all',
        child: Interactive3DEffect(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(AppSize.s20)),
            padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p12, horizontal: AppPadding.p12),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: RoundCorner(
                          child: FractionallySizedBox(
                            widthFactor: .98,
                            child: CachedNetworkImage(
                              imageUrl: product.images.isNotEmpty
                                  ? product.images.first.image!
                                  : "",
                              height: AppSize.s120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: ColorManager.white,
                                height: AppSize.s100,
                                width: AppSize.s100,
                              ),
                              errorWidget: (context, url, error) =>
                                  Skeletonizer(
                                      child: Container(
                                color: ColorManager.white,
                                height: AppSize.s100,
                                width: AppSize.s100,
                              )),
                            ),
                          ),
                        ),
                      ),
                      space(h: AppSize.s10),
                      Text(
                        product.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(),
                      ),
                      if (product.description != null)
                        Text(
                          product.description ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Row(
                        children: [
                          Text(
                            "\$${product.price}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: FontSize.s18,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontConstants.ojuju),
                          ),
                          if (product.discount == true)
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
                ),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: RoundCorner(child: AddToCartWidget(product: product)),
                ),
                Positioned(
                  bottom: 0,
                  left: 2,
                  child: StarRatingWidget(rating: product.averageRating ?? 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
            showMessage(context, "${product.name} ${AppStrings.addedToCart}");
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is AddToCartLoading) {
              return Transform.scale(scale: .8, child: const LoadingWidget());
            } else {
              return IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (product.inventory != null && product.inventory! > 0) {
                      context.read<ProductBloc>().add(AddToCartEvent(
                          params: AddToCartParamsModel(
                              productId: product.id!, quantity: 1)));
                    } else {
                      showErrorMessage(context, AppStrings.outOfStock);
                    }
                  },
                  icon: const Icon(Iconsax.shopping_bag));
            }
          },
        ),
      ),
    );
  }
}
