import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/product_query_params_model.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/ui/home/popular_products_list_view.dart';
import 'package:shoplify/presentation/ui/home/product_gridview.dart';
import 'package:shoplify/presentation/ui/home/new_products_list_view.dart';
import 'package:shoplify/presentation/ui/home/products_category_list_widget.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
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
            context.read<ProductBloc>().add(GetProductCategoryEvent());
            context.read<ProductBloc>().add(GetNewProductsEvent());
            context.read<ProductBloc>().add(GetPopularProductsEvent());
            context.read<ProductBloc>().add(
                GetAllProductsEvent(params: ProductQueryParamsModel(page: 1)));
          },
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is CreateorGetCartFailure) {
                if (state.message.contains("token_not_valid")) {
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
                  return Center(
                      child: RetryButton(
                    message: state.message,
                    retry: () {
                      context.read<ProductBloc>().add(GetOrCreateCartEvent());
                    },
                  ));
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
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: AppStrings.search,
                                        prefixIcon: Icon(
                                          Iconsax.search_normal_1,
                                          size: AppSize.s20,
                                        )),
                                  ),
                                ),
                                space(w: AppSize.s20),
                                RoundCorner(
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {},
                                      icon: const Icon(Iconsax.setting_4)),
                                ),
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
