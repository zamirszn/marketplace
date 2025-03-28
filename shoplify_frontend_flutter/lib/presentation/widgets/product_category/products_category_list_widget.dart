import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/core/config/theme/color_manager.dart';
import 'package:shoplify/domain/entities/product_category_entity.dart';
import 'package:shoplify/presentation/resources/font_manager.dart';
import 'package:shoplify/presentation/resources/styles_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/product_category/bloc/product_category_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsCategoriesListWidget extends StatefulWidget {
  const ProductsCategoriesListWidget({
    super.key,
  });

  @override
  State<ProductsCategoriesListWidget> createState() =>
      _ProductsCategoriesListWidgetState();
}

class _ProductsCategoriesListWidgetState
    extends State<ProductsCategoriesListWidget> {
  @override
  void initState() {
    context.read<ProductCategoryBloc>().add(GetProductCategoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSize.s36,
        child: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
          builder: (context, state) {
            if (state is ProductCategoryLoading ||
                state is ProductCategoryFailure) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: AppPadding.p5, left: AppPadding.p5),
                    child: Skeletonizer(
                      effect: PulseEffect(
                          from: ColorManager.darkBlue.withOpacity(.1),
                          duration: const Duration(seconds: 5),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.s18, vertical: AppSize.s2),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSize.s6),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: ColorManager.darkBlue.withOpacity(.3),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        category.title,
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
