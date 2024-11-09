import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/domain/entities/product_entity.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/home/bloc/product_bloc.dart';
import 'package:marketplace/presentation/ui/home/popular_products_widget.dart';

class PopularProductsListView extends StatelessWidget {
  const PopularProductsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(GetPopularProductsEvent()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is PopularProductLoading ||
              state is PopularProductFailure) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(
                        right: AppPadding.p10, left: AppPadding.p10),
                    child: PopularProductsWidgetSkeleton());
              },
            );
          }

          if (state is PopularProductSuccess) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.popularProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                ProductModelEntity popularProducts =
                    state.popularProducts[index];

                return Padding(
                    padding: EdgeInsets.only(
                        right: AppPadding.p10, left: AppPadding.p10),
                    child: PopularProductsWidget(
                      product: popularProducts,
                    ));
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
