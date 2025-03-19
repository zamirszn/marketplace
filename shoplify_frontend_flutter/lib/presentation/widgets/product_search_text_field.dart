import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
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
          // do search here
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
