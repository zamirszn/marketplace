import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marketplace/app/extensions.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/font_manager.dart';
import 'package:marketplace/presentation/resources/string_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/home/bloc/product_bloc.dart';
import 'package:marketplace/presentation/ui/home/popular_products_list_view.dart';
import 'package:marketplace/presentation/ui/home/product_gridview.dart';
import 'package:marketplace/presentation/widgets/image_carousel.dart';
import 'package:marketplace/presentation/ui/home/new_product_widget.dart';
import 'package:marketplace/presentation/ui/home/new_products_list_view.dart';
import 'package:marketplace/presentation/ui/home/products_category_list_widget.dart';
import 'package:marketplace/presentation/widgets/loading_widget.dart';
import 'package:marketplace/presentation/widgets/retry_button.dart';
import 'package:marketplace/presentation/widgets/snackbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppPadding.p7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Iconsax.shop,
              size: AppSize.s28,
            ),
          ),
        ),
        centerTitle: false,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          CircleAvatar(
            child: Text("M"),
          ),
          space(w: AppSize.s10)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: BlocProvider<ProductBloc>(
          create: (context) => ProductBloc()..add(CreateorGetCartEvent()),
          child: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              print("state is $state");
              // TODO: implement listener
              if (state is AddToCartSuccess) {
                showMessage(context, "Added to cart");
              }
            },
            builder: (context, state) {
              print("state build is $state");

              if (state is CreateorGetCartLoading) {
                return Center(
                  child: LoadingWidget(),
                );
              }
              if (state is CreateorGetCartFailure) {
                return Center(
                    child: RetryButton(
                  message: state.message,
                  retry: () {
                    context.read<ProductBloc>().add(CreateorGetCartEvent());
                  },
                ));
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppPadding.p7),
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
                              Expanded(
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppPadding.p7),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppPadding.p7),
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
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p7),
                        sliver: ProductGridView()),
                    sliverSpace(h: AppSize.s50),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
