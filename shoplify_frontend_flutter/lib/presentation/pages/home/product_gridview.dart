import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/product_query_params_model.dart';
import 'package:shoplify/domain/entities/product_entity.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';
import 'package:shoplify/presentation/resources/values_manager.dart';
import 'package:shoplify/presentation/pages/home/bloc/product_bloc.dart';
import 'package:shoplify/presentation/widgets/product_widget.dart';
import 'package:shoplify/presentation/widgets/empty_widget.dart';
import 'package:shoplify/presentation/widgets/product_widget_skeleton.dart';
import 'package:shoplify/presentation/widgets/retry_button.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  final _scrollController = ScrollController();
  late ProductBloc _productBloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    print("listening");
    if (_isBottom) {
      _productBloc
          .add(GetAllProductsEvent(params: ProductQueryParamsModel(page: 1)));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()
        ..add(GetAllProductsEvent(params: ProductQueryParamsModel(page: 1))),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is AllProductLoading) {
            return SliverGrid.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisExtent: 250,
                  crossAxisSpacing: AppSize.s10,
                  mainAxisSpacing: AppSize.s10),
              itemBuilder: (context, index) {
                return const ProductWidgetSkeleton();
              },
            );
          } else if (state is AllProductEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                  child: EmptyWidget(
                message: AppStrings.noProducts,
              )),
            );
          } else if (state is AllProductFailure) {
            return SliverToBoxAdapter(
              child: Center(
                child: RetryButton(
                  message: state.message,
                  retry: () {
                    context.read<ProductBloc>().add(GetAllProductsEvent(
                        params: ProductQueryParamsModel(page: 1)));
                  },
                ),
              ),
            );
          } else if (state is AllProductSuccess) {
            return SliverToBoxAdapter(
              child: GridView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: state.products.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisExtent: 280,
                    crossAxisSpacing: AppSize.s10,
                    mainAxisSpacing: AppSize.s10),
                itemBuilder: (context, index) {
                  ProductModelEntity products = state.products[index];

                  return ProductWidget(
                    product: products,
                  );
                },
              ),
            );
          }

          return sliverSpace();
        },
      ),
    );
  }
}
