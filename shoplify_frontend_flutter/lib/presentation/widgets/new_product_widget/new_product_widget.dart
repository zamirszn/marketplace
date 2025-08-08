import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/product_details/bloc/product_details_bloc.dart';
import 'package:shoplify/presentation/widgets/blur_background_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewProductWidget extends StatelessWidget {
  const NewProductWidget({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<ProductDetailsBloc>()
            .add(SetProductDetailsEvent(product: product));
        goPush(
          context,
          Routes.productDetailsPage,
          extra: {'heroTag': '${product.id}_new'},
        );
      },
      child: Hero(
        tag: '${product.id}_new',
        child: Stack(
          children: [
            SizedBox(
              height: AppSize.s400,
              width: AppSize.s300,
              child: CachedNetworkImage(
                imageUrl: product.images.first.image!,
                height: AppSize.s120,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: AppSize.s100,
                  width: AppSize.s100,
                  color: ColorManager.blue,
                ),
                placeholder: (
                  context,
                  url,
                ) =>
                    Container(
                  color: ColorManager.blue,
                  height: AppSize.s100,
                  width: AppSize.s100,
                ),
              ),
            ),
            if (product.price != null)
              Positioned(
                  bottom: AppPadding.p20,
                  left: AppPadding.p10,
                  child: BlurBackgroundWidget(
                    child: Text(
                      "\$${roundToTwoDecimalPlaces(product.price) ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(context,
                          color: ColorManager.white,
                          fontSize: FontSize.s23,
                          font: FontConstants.ojuju),
                    ),
                  )),
            if (product.name != null)
              Positioned(
                top: AppPadding.p20,
                right: AppPadding.p10,
                child: BlurBackgroundWidget(
                  child: Text(
                    product.name?.toString() ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(context,
                        color: ColorManager.white,
                        fontSize: FontSize.s18,
                        font: FontConstants.ojuju),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NewProductWidgetSkeleton extends StatelessWidget {
  const NewProductWidgetSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.s20),
      child: Skeletonizer(
        child: Container(
          color: Colors.white,
          height: 400,
          width: 220,
        ),
      ),
    );
  }
}
