import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/search_params_model.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/bloc/filter_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/widgets/go_back_button.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GoBackButton(
                  padding: EdgeInsets.all(AppPadding.p10),
                ),
                Text(
                  AppStrings.filter,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                      font: FontConstants.ojuju, fontSize: FontSize.s30),
                ),
                RoundCorner(
                    child: IconButton(
                        tooltip: AppStrings.reset,
                        onPressed: () {
                          context
                              .read<FilterBottomsheetBloc>()
                              .add(ResetFilterEvent());

                          searchBloc.add(ResetSearchEvent());

                          if (searchBloc.state.searchText.isNotEmpty) {
                            searchBloc.add(SearchProductEvent(
                                useFilterParams: true,
                                searchParamsModel: SearchParamsModel(
                                    searchText: searchBloc.state.searchText,
                                    page: 1)));
                          }
                        },
                        icon: const Icon(Iconsax.refresh)))
              ],
            ),
            space(h: AppSize.s36),
            Text(
              AppStrings.category,
              style: getMediumStyle(fontSize: FontSize.s16),
            ),
            space(h: AppSize.s20),
            BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
              builder: (context, productState) {
                if (productState is ProductCategorySuccess) {
                  final categories = productState.productCategories;
                  return BlocBuilder<FilterBottomsheetBloc,
                      FilterBottomsheetState>(
                    builder: (context, filterState) {
                      return Wrap(
                          children: categories
                              .map((category) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppPadding.p2,
                                        horizontal: AppPadding.p2),
                                    child: ChoiceChip(
                                      label: Text(category.title),
                                      selected:
                                          filterState.selectedCategoryId ==
                                              category.categoryId,
                                      elevation: 0,
                                      selectedColor: ColorManager.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSize.s10)),
                                      onSelected: (bool selected) {
                                        context
                                            .read<FilterBottomsheetBloc>()
                                            .add(FilterByCategoryEvent(
                                                selectedCategory:
                                                    category.categoryId));
                                      },
                                    ),
                                  ))
                              .toList());
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            space(h: AppSize.s36),
            Text(
              AppStrings.sortBy,
              style: getMediumStyle(fontSize: FontSize.s16),
            ),
            space(h: AppSize.s20),
            BlocBuilder<FilterBottomsheetBloc, FilterBottomsheetState>(
              builder: (context, filterState) {
                return Wrap(
                    children: SortProductBy.values
                        .map((sort) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p2,
                                  horizontal: AppPadding.p2),
                              child: ChoiceChip(
                                avatar: Icon(
                                  getSortIcon(sort),
                                ),
                                showCheckmark: false,
                                label: Text(sort.name.toPascalCase()),
                                selected: filterState.sortProductBy == sort,
                                elevation: 0,
                                selectedColor: ColorManager.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s10)),
                                onSelected: (bool selected) {
                                  context
                                      .read<FilterBottomsheetBloc>()
                                      .add(SortProductByEvent(sortBy: sort));
                                },
                              ),
                            ))
                        .toList());
              },
            ),
            space(h: AppSize.s36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.priceRange,
                  style: getMediumStyle(fontSize: FontSize.s16),
                ),
                BlocBuilder<FilterBottomsheetBloc, FilterBottomsheetState>(
                  builder: (context, state) {
                    return Text(
                      "\$${calculateProductRange(state.priceRange.start)} - \$${calculateProductRange(state.priceRange.end)}",
                      style: getBoldStyle(
                          fontSize: FontSize.s16, font: FontConstants.ojuju),
                    );
                  },
                ),
              ],
            ),
            space(h: AppSize.s20),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s10),
              child: ColoredBox(
                color: ColorManager.grey.withAlpha(40),
                child:
                    BlocBuilder<FilterBottomsheetBloc, FilterBottomsheetState>(
                  builder: (context, state) {
                    return RangeSlider(
                      values: state.priceRange,
                      onChanged: (newRange) {
                        context
                            .read<FilterBottomsheetBloc>()
                            .add(FilterPriceRangeEvent(priceRange: newRange));
                      },
                    );
                  },
                ),
              ),
            ),
            space(h: AppSize.s20),
            SizedBox(
              height: AppSize.s50,
              child: BlocBuilder<FilterBottomsheetBloc, FilterBottomsheetState>(
                builder: (context, state) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: ColorManager.black),
                      onPressed:
                          // if there is no filter disable the button
                          state.isFilterEnabled
                              ? () {
                                  if (state.isFilterEnabled == false) return;
                                  // close the bottomsheet
                                  goPopRoute(context);
                                  if (getCurrentRoute(context) !=
                                      Routes.searchPage) {
                                    goPush(
                                      context,
                                      Routes.searchPage,
                                    );
                                  }

                                  // do filter here

                                  searchBloc.add(ResetSearchEvent());

                                  searchBloc.add(SearchProductEvent(
                                      useFilterParams: true,
                                      searchParamsModel: SearchParamsModel(
                                          priceGreaterThan:
                                              "${calculateProductRange(state.priceRange.start)}",
                                          priceLessThan:
                                              "${calculateProductRange(state.priceRange.end)}",
                                          categoryId: state.selectedCategoryId,
                                          discount: state.sortProductBy ==
                                              SortProductBy.discount,
                                          flashSale: state.sortProductBy ==
                                              SortProductBy.flashsale,
                                          searchText:
                                              searchBloc.state.searchText,
                                          page: 1)));
                                }
                              : null,
                      child: Text(
                        AppStrings.apply,
                        style: getSemiBoldStyle(
                            font: FontConstants.ojuju,
                            fontSize: FontSize.s20,
                            color: ColorManager.white),
                      ));
                },
              ),
            ),
            space(h: AppSize.s10),
          ],
        ),
      ),
    );
  }

  IconData? getSortIcon(SortProductBy sort) {
    switch (sort) {
      case SortProductBy.discount:
        return Icons.discount_rounded;

      case SortProductBy.flashsale:
        return Icons.flash_on;
    }
  }
}
