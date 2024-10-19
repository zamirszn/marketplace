import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/config/theme/color_manager.dart';
import 'package:marketplace/presentation/resources/styles_manager.dart';
import 'package:marketplace/presentation/resources/values_manager.dart';
import 'package:marketplace/presentation/ui/home/bloc/home_page_bloc.dart';

class ProductsCategoriesListWidget extends StatelessWidget {
  const ProductsCategoriesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSize.s36,
        child: BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc()..add(GetProductCategoryEvent()),
          child: BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state is HomePageCategorySuccess
                    ? state.categories.length
                    : 0,
                itemBuilder: (context, index) {
                  String category = state is HomePageCategorySuccess
                      ? state.categories[index]
                      : "";
                  return GestureDetector(
                    // onTap: () => state.updateSelectedCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.s18, vertical: AppSize.s2),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSize.s2),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: state is HomePageCategoryUpdate
                            ? state.selectedCategory == category
                                ? ColorManager.black.withOpacity(.85)
                                : ColorManager.color2.withOpacity(.3)
                            : null,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        category,
                        style: getRegularStyle(
                            color: state is HomePageCategoryUpdate
                                ? state.selectedCategory == category
                                    ? ColorManager.white
                                    : ColorManager.black
                                : null),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
