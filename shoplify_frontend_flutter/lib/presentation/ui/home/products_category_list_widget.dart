import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/extensions.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_category_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsCategoriesListWidget extends StatelessWidget {
  const ProductsCategoriesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSize.s36,
        child: BlocProvider<ProductBloc>(
          create: (context) => ProductBloc()..add(GetProductCategoryEvent()),
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductCategoryLoading ||
                  state is ProductCategoryFailure) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: AppPadding.p5, left: AppPadding.p5),
                      child: Skeletonizer(
                        effect: PulseEffect(
                            from: ColorManager.secondary.withOpacity(.1),
                            duration: Duration(seconds: 5),
                            to: ColorManager.black.withOpacity(.01)),
                        child: Text(
                          "******",
                          style: getRegularStyle(fontSize: FontSize.s30),
                        ),
                      ),
                    );
                  },
                );
              }

              if (state is ProductCategorySuccess) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.productCategories.length,
                  itemBuilder: (context, index) {
                    ProductCategoryEntity category =
                        state.productCategories[index];
                    return GestureDetector(
                      // onTap: () => state.updateSelectedCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.s18, vertical: AppSize.s2),
                        margin:
                            const EdgeInsets.symmetric(horizontal: AppSize.s6),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          // color: state is HomePageCategoryUpdate
                          //     ? state.selectedCategory == category
                          //         ? ColorManager.black.withOpacity(.85)
                          //         : ColorManager.color2.withOpacity(.3)
                          //     : null,

                          color: ColorManager.secondary.withOpacity(.3),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          category.title,
                          // style: getRegularStyle(
                          //     // color: state is HomePageCategoryUpdate
                          //     //     ? state.selectedCategory == category
                          //     //         ? ColorManager.white
                          //     //         : ColorManager.black
                          //     //     : null
                          //     ),
                        ),
                      ),
                    );
                  },
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
