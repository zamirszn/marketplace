import 'package:flutter/material.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';

class ProductsCategoriesListWidget extends StatelessWidget {
  const ProductsCategoriesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSize.s36,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 4, //state.storeCategories.length,
          itemBuilder: (context, index) {
            return const FlutterLogo();
            // String category = state.storeCategories[index];
            // return GestureDetector(
            //   onTap: () => state.updateSelectedCategory(category),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: AppSize.s18, vertical: AppSize.s2),
            //     margin: const EdgeInsets.symmetric(horizontal: AppSize.s2),
            //     alignment: Alignment.center,
            //     decoration: ShapeDecoration(
            //       color: state.selectedCategory == category
            //           ? ColorManager.black.withOpacity(.85)
            //           : ColorManager.color2.withOpacity(.3),
            //       shape: const StadiumBorder(),
            //     ),
            //     child: Text(
            //       category,
            //       style: getRegularStyle(
            //           color: state.selectedCategory == category
            //               ? ColorManager.white
            //               : ColorManager.black),
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
