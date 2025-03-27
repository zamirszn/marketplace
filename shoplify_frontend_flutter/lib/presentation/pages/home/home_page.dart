import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_query_params_model.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/pages/home/popular_products_list_view.dart';
import 'package:shoplify/presentation/pages/home/product_gridview.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/filter_products_button.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/bloc/new_product_bloc.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/new_products_list_view.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';
import 'package:shoplify/presentation/widgets/product_category/products_category_list_widget.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget/bloc/popular_product_bloc.dart';
import 'package:shoplify/presentation/widgets/product_search_text_field.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(GetOrCreateCartEvent()),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(GetOrCreateCartEvent());
            context.read<ProductCategoryBloc>().add(GetProductCategoryEvent());
            context.read<NewProductBloc>().add(GetNewProductsEvent());
            context.read<PopularProductBloc>().add(GetPopularProductsEvent());
            context.read<ProductBloc>().add(
                GetAllProductsEvent(params: ProductQueryParamsModel(page: 1)));
          },
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is CreateorGetCartFailure) {
                if (state.errorMessage.contains("token_not_valid")) {
                  //TODO: clear auth token or clear user data on logout or use aunauthenticated enum
                  goto(context, Routes.loginPage);
                  showErrorMessage(context, "Please login");
                }
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is CreateorGetCartLoading) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                } else if (state is CreateorGetCartFailure) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 66, left: AppPadding.p10, right: AppPadding.p10),
                    child: ErrorMessageWidget(
                      retry: () {
                        context.read<ProductBloc>().add(GetOrCreateCartEvent());
                      },
                      message: state.errorMessage,
                    ),
                  );
                } else if (state is CreateorGetCartSuccess) {
                  return CustomScrollView(
                    slivers: [
                      sliverSpace(h: AppSize.s20),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p7),
                        sliver: SliverToBoxAdapter(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            space(h: AppSize.s20),
                            Text(
                              AppStrings.discoverOurNewItems,
                              style: getSemiBoldStyle(
                                font: FontConstants.ojuju,
                                fontSize: AppSize.s24,
                              ),
                            ),
                            space(h: AppSize.s24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const ProductSearchTextField(),
                                space(w: AppSize.s20),
                                const FilterProductsButton(),
                              ],
                            ),
                          ],
                        )),
                      ),

                      sliverSpace(h: AppSize.s20),
                      // product categories
                      const ProductsCategoriesListWidget(),
                      sliverSpace(h: AppSize.s10),
                      // new products
                      const SliverToBoxAdapter(
                        child:
                            SizedBox(height: 280, child: NewProductsListView()),
                      ),
                      sliverSpace(h: AppSize.s20),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p7),
                        sliver: SliverToBoxAdapter(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.popularProducts,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                font: FontConstants.ojuju,
                                fontSize: AppSize.s24,
                              ),
                            ),
                          ],
                        )),
                      ),
                      sliverSpace(h: AppSize.s10),
                      // popular products
                      const SliverToBoxAdapter(
                        child: SizedBox(
                            height: AppSize.s100,
                            child: PopularProductsListView()),
                      ),
                      sliverSpace(h: AppSize.s20),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p7),
                        sliver: SliverToBoxAdapter(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.discoverProducts,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                font: FontConstants.ojuju,
                                fontSize: AppSize.s24,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  AppStrings.viewAll,
                                  overflow: TextOverflow.ellipsis,
                                  style: getLightStyle(
                                    font: FontConstants.poppins,
                                    fontSize: AppSize.s14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                      ),
                      sliverSpace(h: AppSize.s20),
                      // discover products
                      const SliverPadding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppPadding.p7),
                          sliver: ProductGridView()),
                      sliverSpace(h: AppSize.s50),
                    ],
                  );
                } else {
                  return Center(
                      child: RetryButton(
                    message: AppStrings.somethingWentWrong,
                    retry: () {
                      context.read<ProductBloc>().add(GetOrCreateCartEvent());
                    },
                  ));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
