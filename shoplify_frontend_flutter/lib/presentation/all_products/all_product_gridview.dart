import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_model.dart';
import 'package:shoplify/presentation/all_products/bloc/all_products_bloc.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget_skeleton.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class AllProductGridView extends StatefulWidget {
  const AllProductGridView({super.key});

  @override
  State<AllProductGridView> createState() => _AllProductGridViewState();
}

class _AllProductGridViewState extends State<AllProductGridView> {
  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  void getAllProducts() {
    final allProductsBloc = context.read<AllProductsBloc>();
    allProductsBloc
        .add(GetAllProductsEvent(params: ProductQueryParamsModel(page: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllProductsBloc, AllProductsState>(
      builder: (context, state) {
        switch (state.allProductsListStatus) {
          case AllProductsListStatus.initial:
            // loading state
            return SliverGrid.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisExtent: 250,
                  crossAxisSpacing: AppSize.s10,
                  mainAxisSpacing: AppSize.s10),
              itemBuilder: (context, index) {
                return const ProductWidgetSkeleton();
              },
            );

          case AllProductsListStatus.failure:
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p60,
                ),
                child: RetryButton(
                  message: state.errorMessage,
                  retry: () {
                    getAllProducts();
                  },
                ),
              ),
            );

          case AllProductsListStatus.success:
            if (state.productsList.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p40, bottom: AppPadding.p60),
                  child: Center(
                      child: EmptyWidget(
                    message: AppStrings.noProducts,
                    icon: Icon(
                      Iconsax.search_normal_1,
                      size: AppSize.s40,
                    ),
                  )),
                ),
              );
            }

            return SliverToBoxAdapter(
              child: Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.only(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.productsList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 280,
                            crossAxisSpacing: AppSize.s10,
                            mainAxisSpacing: AppSize.s10),
                    itemBuilder: (context, index) {
                      Product products = state.productsList[index];

                      return ProductWidget(
                        product: products,
                      );
                    },
                  ),
                  if (state.isFetching)
                    Column(
                      children: [
                        space(h: AppSize.s40),
                        const LoadingWidget(),
                      ],
                    ),
                  space(h: AppSize.s60),
                ],
              ),
            );
        }
      },
    );
  }
}
