import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/all_products/all_product_gridview.dart';
import 'package:shoplify/presentation/all_products/bloc/all_products_bloc.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/pages/home/popular_products_list_view.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/filter_products_button.dart';
import 'package:shoplify/presentation/widgets/loading/loading_widget.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/bloc/new_product_bloc.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/new_products_list_view.dart';
import 'package:shoplify/presentation/widgets/popular_product_widget/bloc/popular_product_bloc.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';
import 'package:shoplify/presentation/widgets/product_category/products_category_list_widget.dart';
import 'package:shoplify/presentation/widgets/product_search_text_field.dart';
import 'package:shoplify/presentation/widgets/refresh_widget.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';
import 'package:shoplify/presentation/widgets/snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(GetOrCreateCartEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allProductsBloc = context.read<AllProductsBloc>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshWidget(
        onRefresh: () async {
          context.read<ProductBloc>().add(GetOrCreateCartEvent());
          context.read<ProductCategoryBloc>().add(GetProductCategoryEvent());
          context.read<NewProductBloc>().add(GetNewProductsEvent());
          context.read<PopularProductBloc>().add(GetPopularProductsEvent());

          allProductsBloc.add(ResetAllProductListEvent());

          allProductsBloc.add(
              GetAllProductsEvent(params: ProductQueryParamsModel(page: 1)));
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 50) {
              // Load more items when the user reaches the end of the list

              allProductsBloc.add(GetAllProductsEvent(
                  params: ProductQueryParamsModel(
                      page: allProductsBloc.state.page)));
            }
            return false;
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
                  return ErrorMessageWidget(
                    retry: () {
                      context.read<ProductBloc>().add(GetOrCreateCartEvent());
                    },
                    message: state.errorMessage,
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
                                context,
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
                        child: NewProductsListView(),
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
                                context,
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
                        child: PopularProductsListView(),
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
                              AppStrings.ourCatalog,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                context,
                                font: FontConstants.ojuju,
                                fontSize: AppSize.s24,
                              ),
                            ),
                          ],
                        )),
                      ),
                      sliverSpace(h: AppSize.s20),
                      // discover products
                      const SliverPadding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppPadding.p7),
                          sliver: AllProductGridView()),
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
