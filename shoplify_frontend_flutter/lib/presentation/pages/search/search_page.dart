import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/data/models/search_params_model.dart';
import 'package:shoplify/presentation/pages/search/bloc/search_bloc.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/back_button.dart';
import 'package:shoplify/presentation/widgets/filter_products_button.dart';
import 'package:shoplify/presentation/widgets/product_search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    final searchBloc = context.read<SearchBloc>();

    searchBloc.add(SearchProductEvent(
        searchParamsModel: SearchParamsModel(
            searchText: searchBloc.state.searchText, page: 1)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        ]));
  }
}
