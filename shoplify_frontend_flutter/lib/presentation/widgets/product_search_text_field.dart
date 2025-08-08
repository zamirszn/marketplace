import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/pages/home/filter_bottom_sheet/bloc/filter_bottomsheet_bloc.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';

class ProductSearchTextField extends StatefulWidget {
  const ProductSearchTextField({
    super.key,
  });

  @override
  State<ProductSearchTextField> createState() => _ProductSearchTextFieldState();
}

class _ProductSearchTextFieldState extends State<ProductSearchTextField> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.text =
        BlocProvider.of<SearchBloc>(context).state.searchText;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    final filterBloc = context.read<FilterBottomsheetBloc>();

    return Expanded(
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<SearchBloc>().add(UpdateSearchText(text: value));
        },
        onEditingComplete: () {
          if (searchController.text.isEmpty) {
            return;
          }
          if (getCurrentRoute(context) != Routes.searchPage) {
            searchController.clear();
            goPush(
              context,
              Routes.searchPage,
            );
          }
          // do search

          searchBloc.add(ResetSearchEvent());

          if (filterBloc.state.isFilterEnabled) {
            searchBloc.add(SearchProductEvent(
                useFilterParams: true,
                searchParamsModel: SearchParamsModel(
                    priceGreaterThan:
                        "${calculateProductRange(filterBloc.state.priceRange.start)}",
                    priceLessThan:
                        "${calculateProductRange(filterBloc.state.priceRange.end)}",
                    categoryId: filterBloc.state.selectedCategoryId,
                    discount: filterBloc.state.sortProductBy ==
                        SortProductBy.discount,
                    flashSale: filterBloc.state.sortProductBy ==
                        SortProductBy.flashsale,
                    searchText: searchBloc.state.searchText,
                    page: 1)));
          }

          searchBloc.add(SearchProductEvent(
              searchParamsModel: SearchParamsModel(
                  searchText: searchBloc.state.searchText, page: 1)));
        },
        decoration: const InputDecoration(
            hintText: AppStrings.search,
            prefixIcon: Icon(
              Iconsax.search_normal_1,
              size: AppSize.s20,
            )),
      ),
    );
  }
}
