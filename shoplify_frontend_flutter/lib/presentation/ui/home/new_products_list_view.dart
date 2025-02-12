import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/ui/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/new_product_widget.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget_skeleton.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class NewProductsListView extends StatelessWidget {
  const NewProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc()..add(GetNewProductsEvent()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is NewProductLoading) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ProductWidgetSkeleton());
                });
          } else if (state is NewProductEmpty) {
            return const Center(
                child: EmptyWidget(
              message: AppStrings.noPopularProducts,
            ));
          } else if (state is NewProductFailure) {
            return Center(
              child: RetryButton(
                message: state.message,
                retry: () {
                  context.read<ProductBloc>().add(GetNewProductsEvent());
                },
              ),
            );
          } else if (state is NewProductSuccess) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.newProducts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ProductModelEntity newProducts = state.newProducts[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NewProductWidget(
                      product: newProducts,
                    ),
                  );
                });
          }

          return const SizedBox();
        },
      ),
    );
  }
}
