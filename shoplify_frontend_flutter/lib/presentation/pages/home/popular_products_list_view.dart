import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget/bloc/popular_product_bloc.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget/popular_products_widget.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget_skeleton.dart';

class PopularProductsListView extends StatefulWidget {
  const PopularProductsListView({
    super.key,
  });

  @override
  State<PopularProductsListView> createState() =>
      _PopularProductsListViewState();
}

class _PopularProductsListViewState extends State<PopularProductsListView> {
  @override
  void initState() {
    getPopularProduct();
    super.initState();
  }

  getPopularProduct() {
    context.read<PopularProductBloc>().add(GetPopularProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularProductBloc, PopularProductState>(
      builder: (context, state) {
        if (state is PopularProductLoading) {
          return SizedBox(
            height: AppSize.s100,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const Padding(
                    padding: EdgeInsets.only(
                        right: AppPadding.p10, left: AppPadding.p10),
                    child: PopularProductsWidgetSkeleton());
              },
            ),
          );
        } else if (state is PopularProductFailure) {
          return ErrorMessageWidget(
            message: state.message,
            retry: () {
              getPopularProduct();
            },
          );
        } else if (state is PopularProductEmpty) {
          return const SizedBox(
            height: AppSize.s120,
            child: Center(
                child: EmptyWidget(
              message: AppStrings.noPopularProducts,
            )),
          );
        } else if (state is PopularProductSuccess) {
          return SizedBox(
            height: AppSize.s120,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.popularProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Product popularProducts = state.popularProducts[index];

                return Padding(
                    padding: const EdgeInsets.only(
                        right: AppPadding.p10, left: AppPadding.p10),
                    child: PopularProductsWidget(
                      product: popularProducts,
                    ));
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
