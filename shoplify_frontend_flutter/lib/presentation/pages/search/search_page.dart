import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/search_params_model.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/pages/search/search_product_widget.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/error_message_widget.dart';
import 'package:shoplify/presentation/widgets/filter_products_button.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:shoplify/presentation/widgets/product_carousel_skeleton_widget.dart';
import 'package:shoplify/presentation/widgets/product_search_text_field.dart';
import 'package:shoplify/presentation/widgets/product_widget_skeleton.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();

    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(AppPadding.p10),
            child: GoBackButton(
              backgroundColor: ColorManager.lightGrey,
            ),
          ),
          title: Text(
            AppStrings.search,
            style: getRegularStyle(
                font: FontConstants.ojuju, fontSize: FontSize.s20),
          ),
        ),
        body: CustomScrollView(slivers: [
          sliverSpace(h: AppSize.s10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                space(h: AppSize.s10),
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
          sliverSpace(h: AppSize.s10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p7),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: deviceHeight(context) - 150,
                child: deviceWidth(context) > 400
                    // TODO: fix
                    ? GridView.builder(
                        itemCount: 20,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                mainAxisExtent: 250,
                                crossAxisSpacing: AppSize.s10,
                                mainAxisSpacing: AppSize.s10),
                        itemBuilder: (context, index) {
                          return const ProductWidgetSkeleton();
                        },
                      )
                    : BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          switch (state.searchStatus) {
                            case SearchStatus.initial:
                              if (state.isFetching) {
                                return CarouselView.weighted(
                                  scrollDirection: Axis.vertical,
                                  consumeMaxWeight: true,
                                  enableSplash: false,
                                  flexWeights: const [4, 2, 1],
                                  children: List.generate(
                                    5,
                                    (index) =>
                                        const ProductCarouselSkeletonWidget(),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }

                            case SearchStatus.failure:
                              return ErrorMessageWidget(
                                retry: () {
                                  searchBloc.add(SearchProductEvent(
                                      searchParamsModel: SearchParamsModel(
                                          searchText:
                                              searchBloc.state.searchText,
                                          page: 1)));
                                },
                                message: state.errorMessage,
                              );

                            case SearchStatus.success:
                              if (state.searchResultProducts.isEmpty) {
                                return const Center(
                                  child: EmptyWidget(
                                    message: AppStrings.noResultFound,
                                    icon: Icon(
                                      Iconsax.search_normal_1,
                                      size: AppSize.s40,
                                    ),
                                  ),
                                );
                              }

                              return NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent - 50) {
                                    // Load more items when the user reaches the end of the list
                                    searchBloc.add(SearchProductEvent(
                                      searchParamsModel: SearchParamsModel(
                                        searchText: searchBloc.state.searchText,
                                        page: state.page,
                                      ),
                                    ));
                                  }
                                  return false;
                                },
                                child: CarouselView.weighted(
                                  enableSplash: false,
                                  scrollDirection: Axis.vertical,
                                  consumeMaxWeight: true,
                                  flexWeights: const [4, 2, 1],
                                  children: [
                                    // Map the existing products to widgets
                                    ...state.searchResultProducts.map(
                                        (product) => SearchProductWidget(
                                            product: product)),

                                    // Add a loading widget if more items are being loaded
                                    if (!state.hasReachedMax)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: AppPadding.p20),
                                        child: Center(
                                          child: Transform.scale(
                                            scale: .8,
                                            child: const LoadingWidget(),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                          }
                        },
                      ),
              ),
            ),
          )
        ]));
  }
}
