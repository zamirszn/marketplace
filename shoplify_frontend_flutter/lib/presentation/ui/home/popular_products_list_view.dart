import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/ui/home/popular_products_widget.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';

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
          } else if (state is PopularProductEmpty) {
            return Center(
                child: EmptyWidget(
              message: AppStrings.noPopularProducts,
            ));
          } else if (state is PopularProductSuccess) {
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
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
