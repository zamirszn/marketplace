import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/product_category_model.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsCategoriesListWidget extends StatefulWidget {
  const ProductsCategoriesListWidget({
    super.key,
  });

  @override
  State<ProductsCategoriesListWidget> createState() =>
      _ProductsCategoriesListWidgetState();
}

class _ProductsCategoriesListWidgetState
    extends State<ProductsCategoriesListWidget> {
  @override
  void initState() {
    context.read<ProductCategoryBloc>().add(GetProductCategoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSize.s36,
        child: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
          builder: (context, state) {
            if (state is ProductCategoryLoading) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: AppPadding.p5, left: AppPadding.p5),
                    child: Skeletonizer(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadiusGeometry.circular(AppSize.s10),
                        child: Container(
                            color: Colors.white, height: 17, width: 110),
                      ),
                    ),
                  );
                },
              );
            }

            if (state is ProductCategorySuccess) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.productCategories.length,
                itemBuilder: (context, index) {
                  ProductCategory category = state.productCategories[index];
                  return GestureDetector(
                    onTap: () {
                      context.read<SearchBloc>().add(ResetSearchEvent());
                      context.read<SearchBloc>().add(SearchProductEvent(
                          useFilterParams: true,
                          searchParamsModel:
                              SearchParamsModel(category: category.name)));

                      goPush(
                        context,
                        Routes.searchPage,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.s18, vertical: AppSize.s2),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSize.s6),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: ColorManager.blue.withAlpha(30),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        category.name,
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
