import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/bloc/new_product_bloc.dart';
import 'package:shoplify/presentation/widgets/new_product_widget/new_product_widget.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class NewProductsListView extends StatelessWidget {
  const NewProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewProductBloc>(
      create: (context) => NewProductBloc()..add(GetNewProductsEvent()),
      child: BlocBuilder<NewProductBloc, NewProductState>(
        builder: (context, state) {
          if (state is NewProductLoading) {
            return SizedBox(
              height: 280,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const Padding(
                        padding: EdgeInsets.only(
                            right: AppPadding.p2,
                            top: AppPadding.p10,
                            left: AppPadding.p10),
                        child: NewProductWidgetSkeleton());
                  }),
            );
          } else if (state is NewProductEmpty) {
            return const SizedBox(
              height: AppSize.s150,
              child: Center(
                  child: EmptyWidget(
                message: AppStrings.noNewProducts,
                icon: Icon(
                  Iconsax.shop,
                  size: AppSize.s40,
                ),
              )),
            );
          } else if (state is NewProductFailure) {
            return SizedBox(
              height: AppSize.s150,
              child: Center(
                child: RetryButton(
                  message: state.message,
                  retry: () {
                    context.read<NewProductBloc>().add(GetNewProductsEvent());
                  },
                ),
              ),
            );
          } else if (state is NewProductSuccess) {
            return SizedBox(
              height: 280,
              child: CarouselView.weighted(
                  enableSplash: false,
                  scrollDirection: Axis.horizontal,
                  consumeMaxWeight: true,
                  flexWeights: const [3, 2],
                  children: state.newProducts
                      .map((product) => NewProductWidget(product: product))
                      .toList()),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
